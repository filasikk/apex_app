import base64
import json
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta
from pathlib import Path


def parse_robot_output(xml_path: str, screenshot_dir: str = "results/"):
    # Hledáme nejvhodnější output.xml - prioritu má složka results/
    search_paths = [
        Path("results/output.xml"),
        Path("../results/output.xml"),
        Path("output.xml"),
    ]

    found_path = None
    for p in search_paths:
        if p.exists():
            found_path = p
            break

    if found_path:
        xml_path = str(found_path)

    print(f"POUŽÍVÁM SOUBOR: {Path(xml_path).absolute()}")
    print(f"VELIKOST SOUBORU: {Path(xml_path).stat().st_size} bytes")

    tree = ET.parse(xml_path)
    root = tree.getroot()

    # Najdeme časy celého běhu z hlavního statusu
    main_status = root.find("status")
    if main_status is None:
        suite = root.find(".//suite")
        main_status = suite.find("status") if suite is not None else None
    suite_start = main_status.get("start") if main_status is not None else None
    suite_elapsed = main_status.get("elapsed") if main_status is not None else None

    suite_end = None
    if suite_start and suite_elapsed:
        try:
            t_start = datetime.fromisoformat(suite_start)
            t_end = t_start + timedelta(seconds=float(suite_elapsed))
            suite_end = t_end.isoformat()
        except Exception:
            pass

    run = {
        "run_id": datetime.utcnow().isoformat(),
        "app_name": "APEX_TEST_APP",
        "environment": "TEST",
        "started_at": suite_start,
        "finished_at": suite_end,
        "status": None,
        "total_tests": 0,
        "passed_tests": 0,
        "failed_tests": 0,
        "test_cases": [],
    }

    # Projdeme VŠECHNY testy v celém XML souboru (bez ohledu na to, jak hluboko jsou vnořené)
    for test in root.iter("test"):
        name = test.get("name")

        # Najdeme <status> bezpečně
        status_el = test.find("status")
        if status_el is None:
            # XML je poškozené nebo neobsahuje status → přeskočíme test
            continue

        status = status_el.get("status")
        start = status_el.get("start")
        elapsed = status_el.get("elapsed")

        # Duration a Finished At výpočet
        duration_ms = None
        end = None
        if start and elapsed:
            try:
                duration_ms = int(float(elapsed) * 1000)
                t_start = datetime.fromisoformat(start)
                t_end = t_start + timedelta(seconds=float(elapsed))
                end = t_end.isoformat()
            except Exception:
                pass

        # Zpětná kompatibilita pro starší Robot Framework (starttime/endtime)
        if not start:
            start = status_el.get("starttime")
        if not end:
            end = status_el.get("endtime")
        if duration_ms is None and start and end:
            try:
                # Robot Framework starší formáty jsou často YYYYMMDD HH:MM:SS.mmm
                # ale pro jednoduchost zkusíme nejdřív iso
                t1 = datetime.fromisoformat(start)
                t2 = datetime.fromisoformat(end)
                duration_ms = int((t2 - t1).total_seconds() * 1000)
            except Exception:
                pass

        # Najdeme error message (pokud existuje)
        error_message = None
        msg_el = test.find(".//msg[@level='FAIL']")
        if msg_el is not None:
            error_message = msg_el.text

        # Screenshot (pokud existuje)
        # Browser library ukládá cesty k obrázkům do <msg> elementů
        screenshot_b64 = None
        # Hledáme všechny zprávy, které by mohly obsahovat cestu k obrázku
        for msg in test.findall(".//msg"):
            if msg.text and (".png" in msg.text or "screenshot" in msg.text.lower()):
                # Extrahujeme cestu - bývá to buď v <img> tagu (pokud je html="true") nebo jako text
                import re

                # Zkusíme najít cestu k souboru v textu (např. ... results/browser/screenshot/fail-screenshot-1.png)
                match = re.search(r'([^\s\'"]+\.png)', msg.text)
                if match:
                    potential_path = match.group(1)
                    # Cesta v XML může být relativní k výstupnímu adresáři nebo absolutní
                    # Zkusíme několik variant, kde by soubor mohl být
                    paths_to_try = [
                        Path(potential_path),
                        Path(xml_path).parent / potential_path,
                        Path("results/browser/screenshot") / Path(potential_path).name,
                        Path("../results/browser/screenshot")
                        / Path(potential_path).name,
                    ]

                    for p in paths_to_try:
                        if p.exists() and p.is_file():
                            screenshot_b64 = base64.b64encode(p.read_bytes()).decode(
                                "utf-8"
                            )
                            break
                if screenshot_b64:
                    break

        # Statistiky
        run["total_tests"] += 1
        if status == "PASS":
            run["passed_tests"] += 1
        else:
            run["failed_tests"] += 1

        # Uložíme test case
        run["test_cases"].append(
            {
                "test_name": name,
                "status": status,
                "started_at": start,
                "finished_at": end,
                "duration_ms": duration_ms,
                "error_message": error_message,
                "screenshot_blob": screenshot_b64,
            }
        )

    # Celkový stav běhu
    run["status"] = "PASS" if run["failed_tests"] == 0 else "FAIL"

    return run


if __name__ == "__main__":
    result = parse_robot_output("output.xml")

    # Zajistíme, že složka results existuje
    output_dir = Path("results")
    output_dir.mkdir(exist_ok=True)

    output_path = output_dir / "parsed_results.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2, ensure_ascii=False)

    print(f"Výsledky uloženy do {output_path}")

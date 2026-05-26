import json
import sys
from pathlib import Path

import oracledb


def send_results_to_db():
    """
    Načte vygenerovaný JSON a uloží ho přímo do databázové tabulky UTS_VYSLEDKY.
    """
    # 1. Cesta k souboru (změněno na results/parsed_results.json dle předchozích úprav)
    results_path = Path("results/parsed_results.json")

    if not results_path.exists():
        print(f"Chyba: Soubor {results_path} nebyl nalezen.")
        print("Nejdříve spusť: python reporting/parse_results.py")
        return

    # 2. Načtení JSONu
    print(f"Načítám výsledky z {results_path}...")
    try:
        with open(results_path, "r", encoding="utf-8") as f:
            json_string = f.read()
    except Exception as e:
        print(f"Chyba při čtení souboru: {e}")
        return

    # 3. Připojení k DB (údaje z databaze_klicova_slova.resource)
    print("Připojuji se k databázi...")
    try:
        conn = oracledb.connect(
            user="test_ws", password="test_ws", dsn="147.228.51.30:6521/FREEPDB1"
        )
        cursor = conn.cursor()

        # 4. Aktualizace dat (předpokládáme ID = 1)
        print("Aktualizuji tabulku UTS_VYSLEDKY...")
        sql = """
            UPDATE UTS_VYSLEDKY
            SET json_data = :1,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = 1
        """
        cursor.execute(sql, [json_string])

        # Ověření, zda se řádek skutečně zaktualizoval
        if cursor.rowcount == 0:
            print("Upozornění: Řádek s ID=1 nebyl nalezen. Zkouším INSERT...")
            sql_insert = "INSERT INTO UTS_VYSLEDKY (id, json_data) VALUES (1, :1)"
            cursor.execute(sql_insert, [json_string])

        conn.commit()
        print("\nSUCCESS: Výsledky byly úspěšně uloženy do databáze.")

        cursor.close()
        conn.close()
    except oracledb.Error as e:
        print(f"\nCHYBA Databáze: {e}")
    except Exception as e:
        print(f"\nNEOČEKÁVANÁ CHYBA: {e}")


if __name__ == "__main__":
    # Spouštíme z rootu projektu: python reporting/send_results_to_apex.py
    send_results_to_db()

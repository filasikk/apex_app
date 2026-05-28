# APEX Test Flow Framework

Moderní a robustní framework pro automatizované testování Oracle APEX aplikací, vyvinutý s důrazem na stabilitu, rychlost a přehledný monitoring.

---

## 1. Co projekt dělá
Framework umožňuje automatizované testování webových aplikací v prostředí Oracle APEX. Pokrývá celý životní cyklus testu:
- Automatickou přípravu testovacích dat přímo v databázi.
- Simulaci akcí uživatele v prohlížeči (přihlašování, práce s gridy, formuláři).
- Verifikaci výsledků v UI i v databázi.
- Automatické zpracování výsledků a jejich odeslání do monitorovacího dashboardu v APEXu.

## 2. Jaké technologie používá
- **Robot Framework**: Jádro testů v lidsky čitelné formě (BDD).
- **Playwright (Browser Library)**: Stabilní a rychlé ovládání prohlížeče.
- **Python**: Zpracování výsledků a integrace s Oracle DB.
- **Oracle Database / APEX**: Ukládání testovacích dat a vizualizace výsledků.
- **python-dotenv**: Správa citlivých údajů přes prostředí.

## 3. Jak nainstalovat závislosti
1. Přejděte do složky projektu:
   ```bash
   cd apex-test-flow
   ```
2. Vytvořte a aktivujte virtuální prostředí (volitelné):
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Linux/macOS
   .venv\Scripts\activate     # Windows
   ```
3. Nainstalujte balíčky:
   ```bash
   pip install -r requirements.txt
   ```
4. Inicializujte prohlížeče:
   ```bash
   rfbrowser init
   ```

## 4. Jak nastavit .env
Projekt využívá oddělenou konfiguraci od kódu.
1. Zkopírujte šablonu: `cp .env.example .env` (nebo ručně v adresáři `apex-test-flow`).
2. Vyplňte reálné údaje v `.env`:
   - `APEX_BASE_URL`: Základní URL testované aplikace.
   - `APEX_USER_*`: Přihlašovací údaje pro různé role.
   - `TEST_DB_*`: Připojení k Oracle DB (DSN, uživatel, heslo).
3. Framework automaticky interpoluje tyto hodnoty do YAML souborů v `variables/`.

## 5. Jak spustit testy
Testy se spouštějí z kořenové složky `apex-test-flow`:
```bash
# Spuštění všech testů
robot -d results tests/

# Spuštění konkrétního testu
robot -d results tests/prihlaseni.robot

# Spuštění s viditelným prohlížečem (v .env nastavte HEADLESS=false)
```

## 6. Jak zobrazit výsledky
- **HTML Log/Report**: Po každém běhu vzniknou v `results/` soubory `log.html` a `report.html`.
- **Screenshots**: Snímky obrazovky při chybách najdete v `results/browser/screenshot/`.
- **JSON Summary**: Technický přehled vygenerujete pomocí `python reporting/parse_results.py`.

## 7. Jak přidat nový test
1. Vytvořte nový `.robot` soubor v `tests/`.
2. Využívejte existující klíčová slova z `resources/` (např. `spolecne.resource`).
3. Pokud potřebujete nová data, přidejte je do `.env` a případně do `variables/uzivatele.yaml` pomocí placeholderu `${VAR}`.
4. Podrobný návod najdete v [docs/typical_workflow.md](apex-test-flow/docs/typical_workflow.md).

## 8. Jak funguje databázový setup a teardown
- Skripty pro přípravu dat jsou v `db/setup/` a pro úklid v `db/teardown/`.
- Testy využívají `DatabaseLibrary` pro spouštění těchto skriptů před/po testovacím scénáři.
- Tím je zajištěna izolace testů a čistota prostředí.

## 9. Jak je navržen monitoring výsledků
1. Po doběhnutí testů se spustí parser: `python reporting/parse_results.py`.
2. Výsledný JSON je odeslán do APEXu: `python reporting/send_results_to_apex.py`.
3. V APEX aplikaci (tabulka `UTS_VYSLEDKY`) jsou data vizualizována na real-time dashboardu.

## 10. Známá omezení
- **VPN**: Pro přístup k Oracle DB v síti ZČU je vyžadováno aktivní VPN připojení.
- **Oracle Client**: Pro Python skripty je nutné mít nainstalovaný a nakonfigurovaný Oracle Instant Client (nebo použít `python-oracledb` v thin módu).
- **Headless mode**: Některé interakce (např. SSO přihlášení) se mohou v headless módu chovat odlišně.

---
*Finální výstup odborné praxe 2026.*

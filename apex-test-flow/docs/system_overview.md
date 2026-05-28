# Přehled systému (System Overview)

Tento dokument vysvětluje, jak framework funguje jako celek, popisuje jeho hlavní části a vztahy mezi nimi.

## 1. Testovací scénáře
Testy jsou uloženy v adresáři `tests/` a jsou psány v českém jazyce pomocí BDD syntaxe (Když..., Pak...). Jsou rozděleny do logických celků:
- **Přihlašování**: Ověření přístupu pro různé uživatelské role.
- **Formuláře**: Testování business logiky (přihlášky na kurzy, validace).
- **Interactive Grids**: Kontrola zobrazení dat a oprávnění na úrovni sloupců.
- **Navigace**: Ověření struktury menu a dostupnosti stránek.

## 2. Vlastní Robot Framework klíčová slova
Framework využívá vrstvenou architekturu klíčových slov uložených v `resources/`:
- **Business Level**: Lidsky čitelná slova (např. `Když se přihlásím jako "admin"`).
- **Technical Level**: Skrývají technické detaily APEXu (např. `Zajisti rozbalené menu`, `Klikni na media list title`).
- Tato separace umožňuje snadnou údržbu – při změně UI v APEXu stačí upravit klíčové slovo na jednom místě.

## 3. Konfigurace aplikace a uživatelů
Konfigurace je navržena tak, aby citlivé údaje nebyly součástí kódu:
- **.env.example**: Centrální místo pro veškerá hesla, URL a DSN.
- **YAML soubory** (`variables/`): Definují strukturu dat (např. role uživatelů), ale reálné hodnoty si berou z prostředí pomocí placeholderů `${VAR}`.
- **env_loader.py**: Python most, který dynamicky vstřikuje hodnoty z prostředí do YAML souborů při startu testů.

## 4. Browser automatizace
Pro ovládání prohlížeče je použita **Browser Library (Playwright)**.
- **Zero-Sleep Architecture**: Framework nečeká fixní čas, ale využívá `Wait For Elements State` (dynamické čekání).
- **Headless Mode**: Možnost spouštění testů bez viditelného okna (vhodné pro CI/CD).
- **Automatické screenshoty**: Při každém selhání testu je automaticky pořízen snímek obrazovky.

## 5. Databázový setup a teardown
Framework zajišťuje plnou kontrolu nad testovacími daty:
- **Setup**: Před spuštěním testu se pomocí SQL skriptů (`db/setup/`) připraví potřebná data v Oracle DB.
- **Teardown**: Po skončení testu (i v případě chyby) se data uklidí pomocí skriptů v `db/teardown/`.
- Pro komunikaci s DB se využívá `DatabaseLibrary` a ovladač `python-oracledb`.

## 6. Zpracování výsledků
Po doběhnutí testovací sady (vygenerování `output.xml`) nastupuje post-processing:
- Skript `reporting/parse_results.py` analyzuje výsledky.
- Extrahuje klíčové informace (stav, čas, chybové hlášky, cesty k screenshotům).
- Výstupem je standardizovaný soubor `parsed_results.json`.

## 7. Odesílání výsledků do APEX
Vlastní integrace s monitorovacím systémem:
- Skript `reporting/send_results_to_apex.py` načte JSON s výsledky.
- Pomocí `python-oracledb` se připojí k cílové databázi.
- Data uloží do tabulky `UTS_VYSLEDKY` (CLOB sloupec pro JSON).

## 8. Monitorovací dashboard
Výsledky jsou vizualizovány přímo v APEX aplikaci:
- **Dashboard**: Real-time přehled o úspěšnosti testů.
- **Error Log**: Detailní výpis chyb včetně screenshotů převedených na Base64.
- **Historie**: Sledování trendu stability aplikace v čase.


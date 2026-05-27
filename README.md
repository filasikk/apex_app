# APEX Test Flow Framework 

Moderní a robustní framework pro automatizované testování Oracle APEX aplikací, vyvinutý s důrazem na stabilitu, rychlost a přehledný monitoring.

Tento projekt vznikl jako výsledek odborné praxe (2026). Ukazuje integraci BDD přístupu (Robot Framework) s moderním ovládáním prohlížeče (Playwright) a přímým napojením na Oracle DB a APEX dashboard.

##  Hlavní technologie

- **Robot Framework** (jádro testů v lidsky čitelné formě)
- **Playwright (Browser Library)** (bleskové a stabilní ovládání prohlížeče)
- **Python** (automatizovaný processing výsledků a DB integrace)
- **Oracle Database / APEX** (přímá validace dat a real-time monitoring)

##  Klíčové vlastnosti

- **Zero-Sleep Architecture:** Žádné fixní čekání. Framework využívá dynamické `Wait For Elements State`, což zkracuje dobu běhu testů na minimum.
- **Direct DB Integration:** Testy si samy připravují a uklízejí testovací data přímo v Oracle DB.
- **APEX Monitoring Dashboard:** Výsledky jsou po každém běhu automaticky odeslány do APEX aplikace, kde jsou vizualizovány na dashboardu.

##  Rychlý start

1. **Příprava prostředí:**
   ```bash
   cd apex-test-flow
   pip install -r requirements.txt
   rfbrowser init
   ```

2. **Spuštění kompletní sady testů:**
   ```bash
   # 1. Spuštění testů (vygeneruje XML výstup)
   robot -d results tests/

   # 2. Zpracování výsledků do JSON (včetně screenshotů chyb)
   python reporting/parse_results.py

   # 3. Odeslání výsledků do APEX monitoringu
   python reporting/send_results_to_apex.py
   ```

##  Monitoring a Výsledky

- **Lokální reporty:** Detailní HTML logy najdete vždy v `apex-test-flow/results/`.
- **APEX Dashboard:** Real-time přehled o stavu aplikace (včetně error logů a historie) je dostupný přímo v monitorovací APEX stránce (napojené na tabulku `UTS_VYSLEDKY`).

##  Dokumentace

Podrobné informace najdete v adresáři `apex-test-flow/docs/`:
- [Přehled systému](apex-test-flow/docs/system_overview.md) - Architektura a principy.
- [Pracovní postup](apex-test-flow/docs/typical_workflow.md) - Jak psát a spouštět nové testy.
- [Deník práce](apex-test-flow/docs/worklog.md) - Průběh vývoje v rámci praxe.
- [Zadání praxe](apex-test-flow/docs/zadani_praxe_apex_testovani.md) - Původní požadavky projektu.

---
*Finální výstup odborné praxe 2026.*

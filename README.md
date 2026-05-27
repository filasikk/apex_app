# APEX Test Flow Framework 🚀

Proof of concept (PoC) testovacího frameworku pro automatizované testování Oracle APEX aplikací.

Tento projekt vznikl v rámci praxe s cílem ukázat, jak lze efektivně, stabilně a čitelně testovat komplexní APEX aplikace pomocí moderních open-source nástrojů.

## 🛠 Hlavní technologie

- **Robot Framework** (BDD testovací jádro)
- **Playwright (Browser Library)** (ovládání prohlížeče)
- **Python** (reporting a pomocné skripty)
- **DatabaseLibrary** (přímá integrace s Oracle DB)

## 📋 Požadavky

- Python 3.10+
- Node.js 18+ (pro Playwright)
- Přístup k Oracle DB (pro databázové testy)

## 🚀 Rychlý start

1. **Instalace závislostí:**
   ```bash
   pip install -r apex-test-flow/requirements.txt
   rfbrowser init
   ```

2. **Spuštění demo testů (Interactive Grid & Menu):**
   ```bash
   robot --outputdir results apex-test-flow/tests/interactive_grid.robot
   ```

3. **Spuštění komplexního flow s databází:**
   ```bash
   robot --outputdir results apex-test-flow/tests/formulare_prihlasky.robot
   ```

## 📊 Výsledky a Reporting

Po každém spuštění najdete v adresáři `results/`:
- `report.html`: Přehledný grafický report.
- `log.html`: Detailní technický log každého kroku.
- `browser/screenshot/`: Snímky obrazovky v případě chyby.

Pro vygenerování JSON souhrnu pro další integraci spusťte:
```bash
python apex-test-flow/reporting/parse_results.py
```

## 📖 Dokumentace

Podrobné informace najdete v adresáři `apex-test-flow/docs/`:
- [Přehled systému](apex-test-flow/docs/system_overview.md)
- [Pracovní postup pro testery](apex-test-flow/docs/typical_workflow.md)
- [Deník práce](apex-test-flow/docs/worklog.md)
- [ADR - Rozhodnutí o architektuře](apex-test-flow/docs/adr/)

---
*Vytvořeno jako výsledek odborné praxe 2026.*

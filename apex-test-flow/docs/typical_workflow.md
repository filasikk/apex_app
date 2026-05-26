# Pracovní postup

Tohle slouží jako návod pro testery a vývojáře, jak pracovat s tímto testovacím frameworkem.

## 1. Příprava nového testu

Při psaní nového testu postupujte takto:

1.  **Analýza:** Definujte scénář v češtině (Když..., Pak...).
2.  **Příprava dat:** Pokud test vyžaduje specifický stav aplikace, připravte SQL skript v `db/setup/` a přidejte klíčové slovo do `resources/databaze_klicova_slova.resource`.
3.  **Implementace:**
    *   Vytvořte nebo upravte soubor v `tests/` (přípona `.robot`).
    *   Využívejte existující klíčová slova z `resources/`. Pokud chybí, doplňte je do příslušného `.resource` souboru.
4.  **Selektory:** Preferujte textové selektory (např. `text="Uložit"`) nebo stabilní CSS/ID.

## 2. Spouštění testů

Testy lze spouštět z terminálu z kořenového adresáře projektu.

### Spuštění všech testů:
```bash
robot --outputdir results apex-test-flow/tests/
```

### Spuštění konkrétního souboru:
```bash
robot --outputdir results apex-test-flow/tests/interactive_grid.robot
```

### Spuštění v "headless" módu (bez viditelného okna prohlížeče):
```bash
robot --outputdir results --variable HEADLESS:true apex-test-flow/tests/
```

## 3. Analýza výsledků

1.  **HTML Report:** Otevřete `results/report.html` v prohlížeči pro vizuální přehled.
2.  **Screenshots:** Pokud test selže, najdete snímek obrazovky v `results/browser/screenshot/`.
3.  **JSON Summary:** Pro technické zpracování spusťte parser:
    ```bash
    python apex-test-flow/reporting/parse_results.py
    ```
    Výsledek najdete v `results/summary.json`.

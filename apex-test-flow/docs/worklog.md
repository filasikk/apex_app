# Deník práce (Worklog)

Tento deník dokumentuje průběh praxe na vytvoření testovacího frameworku pro Oracle APEX.

### Den 1-3: Návrh a první krůčky
- Výběr technologického stacku (Robot Framework + Playwright).
- Prvotní konfigurace prostředí a napojení na Browser library.
- První pokusy o selektory v APEX aplikaci.

### Den 4: Gridy a menu
- Implementace robustní navigace přes menu i karty.
- Vytvoření klíčových slov pro kontrolu Interactive Gridu.
- Rozlišení rolí uživatelů (Admin vs. Nevedoucí) a ověření oprávnění (viditelnost sloupců).

### Den 5: Databáze a formuláře
- Propojení s Oracle DB přes DatabaseLibrary.
- Vytvoření Setup/Teardown skriptů pro izolaci testů.
- Automatizace přihlášky na kurz s různými stavy (plný, po deadlinu).

### Den 6: Reporting
- Návrh struktury pro export výsledků.
- Implementace Python parseru (`parse_results.py`) pro převod XML na JSON.
- Příprava payloadu pro budoucí dashboard v APEXu.

### Den 7: Finalizace
- **Integrace:** Propojení všech částí do jednoho celku.
- **Stabilizace:** Odstranění "křehkých" selektorů, oprava strict mode chyb.
- **Dokumentace:** Vytvoření System Overview, Typical Workflow a finalizace README.
- **Předání:** Příprava demo scénáře pro prezentaci.

# Přehled testovacího frameworku (System Overview)

Dokument popisuje architekturu a fungování frameworku pro automatizované testování aplikací v Oracle APEX.

## Architektura

Framework je postaven na kombinaci moderních open-source nástrojů, které zajišťují stabilitu, rychlost a snadnou rozšiřitelnost.

### Hlavní komponenty
1. **Robot Framework:** Jádro celého systému, které umožňuje psát testy v lidsky čitelné formě (BDD - Behavior Driven Development) v češtině.
2. **Browser Library:** Moderní nástroj pro ovládání prohlížeče, který je výrazně rychlý a stabilní. Automaticky řeší čekání na prvky.
3. **Database Library:** Umožňuje přímé propojení s Oracle databází pro přípravu testovacích dat (Setup) a jejich následné smazání (Teardown).
4. **Python Reporting:** Vlastní skripty pro zpracování výsledků a jejich transformaci do formátu JSON pro další integraci.

## Struktura projektu 

- `tests/`: Obsahuje testovací scénáře rozdělené podle modulů (přihlášení, gridy, formuláře).
- `resources/`: Obsahuje nízkoúrovňová klíčová slova, která schovávají technické detaily APEXu (selektory, klikání).
- `db/`: SQL skripty pro manipulaci s testovacími daty v databázi.
- `variables/`: Konfigurační soubory.
- `reporting/`: Skripty pro analýzu výsledků.

## Hlavní principy

- **BDD (Behavior Driven Development):** Testy jsou psány jako příběhy (Když..., Pak...), což umožňuje jejich snadnou kontrolu i neprogramátorům.
- **Surgical Selection:** Selektory jsou navrženy tak, aby byly odolné proti změnám v APEXu (využívají texty, role a stabilní CSS třídy).
- **Data Isolation:** Každý test si připravuje svá vlastní data v databázi a po sobě je uklízí, čímž se předchází ovlivňování výsledků.

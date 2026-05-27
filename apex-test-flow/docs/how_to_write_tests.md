# Jak psát nové testy

Tento návod slouží pro testery, kteří chtějí přidávat nové scénáře do frameworku.

## 1. Struktura testu
Testy píšeme v `.robot` souborech ve složce `tests/`. Používáme česká klíčová slova.

```robot
*** Test Cases ***
Moje nová kontrola
    Pokud jsem přihlášen jako "admin"
    Když otevřu stránku "Moje Stránka"
    Pak vidím text "Vítejte"
```

## 2. Používání existujících klíčových slov
Dostupná slova najdete v `resources/spolecne.resource` a specializovaných souborech:
- **Navigace:** `Když otevřu stránku "Název"`
- **Menu:** `Pak boční menu by mělo obsahovat položky`
- **Gridy:** `Pak mřížka by měla obsahovat sloupce`
- **Formuláře:** `A zároveň ve formuláři vyplním hodnoty`

## 3. Práce s databází
Pokud test vyžaduje specifická data, použijte `resources/databaze_klicova_slova.resource`:
- `Pokud připravím kurz s volnou kapacitou`
- `Odstraň testovací data` (vždy v Setupu nebo Teardownu)

## 4. Spouštění testů
Pro spuštění všech testů a vygenerování reportů:
```bash
robot -d results tests/
```
Poté spusťte reporting skripty pro aktualizaci dashboardu.

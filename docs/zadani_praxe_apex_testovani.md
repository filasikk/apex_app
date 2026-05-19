# Zadání praxe: Testovací framework pro Oracle APEX aplikace

## Kontext

Cílem praxe je navrhnout a vytvořit **proof of concept testovacího frameworku pro automatizované testování Oracle APEX aplikací**.

APEX aplikace jsou webové aplikace, které obsahují stránky, formuláře, interactive gridy, menu, statický obsah a různé úrovně oprávnění podle přihlášeného uživatele. Ruční kontrola těchto prvků je opakovaná, pracná a náchylná k chybám. Vaším úkolem je připravit technické řešení, které umožní tyto kontroly zapisovat čitelně, spouštět automatizovaně a výsledky přehledně zobrazovat.

Testy mají být psané ve stylu **Gherkin / BDD**, tedy tak, aby testovací scénáře byly srozumitelné i člověku, který není autorem automatizačního kódu.

Příklad zamýšlené čitelnosti:

```gherkin
Scénář: Student vidí přehled přihlášek
  Pokud jsem přihlášen jako "student_a"
  Když otevřu stránku "Přihlášky"
  Pak vidím interactive grid "Přehled přihlášek"
  A zároveň grid obsahuje sloupce "Jméno", "Příjmení", "Stav"
  A zároveň nemohu upravovat záznamy
```

---

## Hlavní cíl

Navrhněte a vytvořte **testovací flow pro Oracle APEX aplikace**, které umožní:

1. zapisovat testy v čitelném českém Gherkin / BDD stylu,
2. testovat přihlášení za různé uživatele,
3. ověřovat dostupnost konkrétních APEX stránek,
4. kontrolovat obsah interactive gridů,
5. kontrolovat oprávnění k editaci záznamů,
6. kontrolovat statický obsah stránky,
7. kontrolovat položky v bočním menu,
8. testovat vyplnění formuláře a následné ověření uložených hodnot v interactive gridu,
9. připravovat a uklízet testovací data v databázi v izolovaném testovacím prostředí,
10. ukládat výsledky testů tak, aby byly monitorovatelné,
11. zobrazovat výsledky ideálně v samostatné APEX stránce / dashboardu,
12. průběžně dokumentovat odvedenou práci, technická rozhodnutí a typický pracovní flow.

---

## Doporučený technologický směr

Preferované řešení:

- Python,
- Robot Framework,
- Robot Framework Browser Library,
- Playwright,
- Gherkin / BDD styl testů,
- výstupy ve formátu JSON / XML / JUnit XML / vlastní API payload,
- přístup do izolované testovací Oracle databáze,
- jednoduchý dashboard výsledků v Oracle APEX.

Robot Framework je vhodný proto, že umožňuje psát testy pomocí klíčových slov a podporuje BDD styl zápisu. Browser Library je nadstavba pro automatizaci prohlížeče založená na Playwrightu.

Alternativně lze pro proof of concept použít přímo **Playwright for Python**, ale výhodou Robot Frameworku je jednodušší tvorba vlastních doménových klíčových slov typu `Vidím interactive grid`, `Otevřu stránku`, `Uživatel může upravovat záznamy`.

---

# Rozsah práce

## 1. Analýza APEX aplikace

Nejprve zjistěte, jak vypadá testovaná APEX aplikace z pohledu uživatele.

Zaměřte se na:

- jak funguje přihlášení,
- jak se pozná úspěšné přihlášení,
- jak se přechází na konkrétní stránku,
- jak v HTML vypadají APEX regiony,
- jak identifikovat interactive grid,
- jak najít sloupce interactive gridu,
- jak poznat, zda je grid editovatelný,
- jak najít boční menu,
- jak ověřit statický text na stránce.

Výstupem této části bude krátký technický dokument `analysis.md`, který popíše zjištění a doporučení pro selektory.

---

## 2. Návrh architektury testů

Navrhněte strukturu projektu tak, aby bylo možné testy dlouhodobě rozšiřovat.

Doporučená struktura:

```text
apex-test-flow/
├── README.md
├── requirements.txt
├── package.json                 # pokud bude potřeba pro Browser/Playwright
├── .env.example
├── tests/
│   ├── prihlaseni.robot
│   ├── navigace.robot
│   ├── interactive_grid.robot
│   ├── menu.robot
│   └── formulare_prihlasky.robot
├── resources/
│   ├── apex_klicova_slova.resource
│   ├── prihlaseni_klicova_slova.resource
│   ├── grid_klicova_slova.resource
│   ├── menu_klicova_slova.resource
│   ├── formular_klicova_slova.resource
│   ├── databaze_klicova_slova.resource
│   └── spolecne.resource
├── variables/
│   ├── uzivatele.example.yaml
│   ├── stranky.yaml
│   ├── aplikace.yaml
│   └── test_data.yaml
├── db/
│   ├── setup/
│   │   ├── kurz_pred_deadlinem.sql
│   │   ├── kurz_po_deadlinu.sql
│   │   └── kurz_plny.sql
│   ├── teardown/
│   │   └── uklid_testovacich_dat.sql
│   └── README.md
├── results/
│   └── .gitkeep
├── reporting/
│   ├── parse_results.py
│   ├── send_results_to_apex.py
│   └── result_schema.md
└── docs/
    ├── analysis.md
    ├── architecture.md
    ├── selectors.md
    ├── how_to_write_tests.md
    ├── system_overview.md
    ├── typical_workflow.md
    ├── worklog.md
    └── adr/
        └── 0001-volba-testovaciho-stacku.md
```

Architektura musí oddělit:

- testovací scénáře,
- vlastní klíčová slova,
- konfiguraci aplikace,
- konfiguraci uživatelů,
- reporting výsledků,
- databázovou přípravu a úklid testovacích dat,
- dokumentaci systému,
- deník práce a záznamy technických rozhodnutí.

---

## 3. Návrh českých Gherkin / BDD klíčových slov

Vytvořte sadu klíčových slov, která umožní psát testy co nejblíže běžnému jazyku.

Používejte český BDD styl:

- `Scénář`,
- `Pokud`,
- `Když`,
- `Pak`,
- `A zároveň`,
- `Ale`.

Robot Framework interně běžně pracuje s anglickými prefixy `Given / When / Then / And`, ale pro čitelnost zadání a testovacích scénářů v rámci tohoto proof of conceptu navrhněte českou vrstvu klíčových slov. Prakticky to znamená, že samotné názvy klíčových slov budou v češtině, například `jsem přihlášen jako`, `otevřu stránku`, `vidím interactive grid`.

### Přihlášení

```gherkin
Scénář: Uživatel se úspěšně přihlásí
  Pokud jsem odhlášen
  Když se přihlásím jako "uzivatel_x"
  Pak vidím, že jsem přihlášen jako "uzivatel_x"
```

```gherkin
Scénář: Test začíná s přihlášeným uživatelem
  Pokud jsem přihlášen jako "uzivatel_x"
  Pak vidím úvodní stránku aplikace
```

Minimální sada klíčových slov:

```text
jsem přihlášen jako "uzivatel_x"
jsem odhlášen
se přihlásím jako "uzivatel_x"
vidím, že jsem přihlášen jako "uzivatel_x"
```

---

### Navigace

```gherkin
Scénář: Uživatel otevře konkrétní stránku
  Pokud jsem přihlášen jako "uzivatel_x"
  Když otevřu stránku "Přehled"
  Pak jsem na stránce "Přehled"
  A zároveň URL obsahuje "f?p="
```

Minimální sada klíčových slov:

```text
otevřu stránku "Název stránky"
jsem na stránce "Název stránky"
URL obsahuje "f?p="
```

---

### Interactive grid

```gherkin
Scénář: Uživatel vidí očekávaný interactive grid
  Pokud jsem přihlášen jako "uzivatel_x"
  Když otevřu stránku "Přihlášky"
  Pak vidím interactive grid "Přehled přihlášek"
  A zároveň grid "Přehled přihlášek" obsahuje sloupce:
    | Název sloupce |
    | Jméno         |
    | Příjmení      |
    | Stav          |
```

```gherkin
Scénář: Grid neobsahuje interní sloupec
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Přihlášky"
  Pak vidím interactive grid "Přehled přihlášek"
  Ale grid "Přehled přihlášek" neobsahuje sloupec "Interní poznámka"
```

```gherkin
Scénář: Grid obsahuje data
  Pokud jsem přihlášen jako "referent"
  Když otevřu stránku "Přihlášky"
  Pak grid "Přehled přihlášek" obsahuje alespoň 1 záznam
```

Minimální sada klíčových slov:

```text
vidím interactive grid "Název gridu"
grid "Název gridu" obsahuje sloupce
grid "Název gridu" neobsahuje sloupec "Název sloupce"
grid "Název gridu" obsahuje alespoň 1 záznam
grid "Název gridu" je editovatelný
grid "Název gridu" není editovatelný
upravím hodnotu ve sloupci "Název sloupce" na "Nová hodnota"
změnu lze uložit
změnu nelze uložit
```

---

### Editace záznamů

```gherkin
Scénář: Oprávněný uživatel může upravovat grid
  Pokud jsem přihlášen jako "admin"
  Když otevřu stránku "Přihlášky"
  Pak grid "Přehled přihlášek" je editovatelný
  Když upravím hodnotu ve sloupci "Stav" na "Schváleno"
  Pak změnu lze uložit
```

```gherkin
Scénář: Běžný uživatel nemůže upravovat grid
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Přihlášky"
  Pak grid "Přehled přihlášek" není editovatelný
  A zároveň změnu nelze uložit
```

---

### Statický obsah

```gherkin
Scénář: Stránka obsahuje očekávaný statický text
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Domů"
  Pak vidím text "Vítejte v aplikaci"
  A zároveň stránka obsahuje nadpis "Přehled"
```

```gherkin
Scénář: Student nevidí administrační informaci
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Domů"
  Pak nevidím text "Administrace systému"
```

Minimální sada klíčových slov:

```text
vidím text "Text na stránce"
nevidím text "Text na stránce"
stránka obsahuje nadpis "Nadpis"
```

---

### Boční menu

```gherkin
Scénář: Uživatel vidí očekávané položky v bočním menu
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Domů"
  Pak v bočním menu vidím položku "Přihlášky"
  A zároveň v bočním menu vidím položku "Můj profil"
```

```gherkin
Scénář: Student nevidí administrační menu
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Domů"
  Pak v bočním menu vidím položku "Přihlášky"
  Ale v bočním menu nevidím položku "Administrace"
```

```gherkin
Scénář: Uživatel vidí přesně definované položky menu
  Pokud jsem přihlášen jako "referent"
  Když otevřu stránku "Domů"
  Pak v bočním menu vidím položky:
    | Položka      |
    | Domů         |
    | Přihlášky    |
    | Nastavení    |
```

Minimální sada klíčových slov:

```text
v bočním menu vidím položku "Název položky"
v bočním menu nevidím položku "Název položky"
v bočním menu vidím položky
```

---

### Oprávnění

```gherkin
Scénář: Uživatel vidí pouze povolené části aplikace
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Domů"
  Pak uživatel vidí pouze povolené položky menu
  A zároveň uživatel nesmí upravovat záznamy
```

```gherkin
Scénář: Administrátor má rozšířená oprávnění
  Pokud jsem přihlášen jako "admin"
  Když otevřu stránku "Administrace"
  Pak uživatel může upravovat záznamy
  A zároveň v bočním menu vidím položku "Administrace"
```

Minimální sada klíčových slov:

```text
uživatel může upravovat záznamy
uživatel nesmí upravovat záznamy
uživatel vidí pouze povolené položky menu
```

---

### Formuláře a ověření uložených dat v gridu

Součástí proof of conceptu musí být také end-to-end scénář, ve kterém test nejprve vyplní formulář na jedné stránce, odešle jej a potom na jiné stránce ověří, že se zadané hodnoty objevily v interactive gridu.

Obecný scénář:

```gherkin
Scénář: Hodnoty odeslané přes formulář jsou vidět v přehledovém gridu
  Pokud jsem přihlášen jako "student"
  A zároveň existuje testovací záznam "kurz_pro_formularovy_test"
  Když otevřu stránku "Přihláška na kurz"
  A zároveň ve formuláři "Přihláška" vyplním hodnoty:
    | Položka        | Hodnota                  |
    | Kurz           | kurz_pro_formularovy_test |
    | Poznámka       | Automatizovaný test       |
  A zároveň odešlu formulář "Přihláška"
  Pak jsem na stránce "Moje přihlášky"
  A zároveň v interactive gridu "Moje přihlášky" vidím řádek s hodnotami:
    | Sloupec        | Hodnota                  |
    | Kurz           | kurz_pro_formularovy_test |
    | Stav           | Přihlášen                |
    | Poznámka       | Automatizovaný test       |
```

Minimální sada klíčových slov:

```text
existuje testovací záznam "identifikator"
ve formuláři "Název formuláře" vyplním hodnoty
odešlu formulář "Název formuláře"
v interactive gridu "Název gridu" vidím řádek s hodnotami
v interactive gridu "Název gridu" nevidím řádek s hodnotami
```

---

### Databázový setup a teardown

Některé testy nelze spolehlivě ověřit pouze přes uživatelské rozhraní. Typicky jde o případy, kdy je potřeba vynutit konkrétní stav dat: kurz po deadlinu, plný kurz, kurz s volnou kapacitou nebo již existující přihláška.

Automatizované testování se očekává v **izolovaném testovacím prostředí**, takže řízená manipulace s databází je přípustná. Nesmí se ale provádět nekontrolovaně. Každý test, který mění databázi, musí mít přípravnou a úklidovou fázi.

Požadavek:

- před testem vytvořit nebo upravit potřebná testovací data,
- používat jednoznačný prefix testovacích dat, například `AUTO_TEST_`,
- po testu odstranit vytvořené přihlášky, kurzy a pomocné záznamy,
- zajistit, aby opakované spuštění testů neskončilo kvůli datům z předchozího běhu,
- dokumentovat, které tabulky a sloupce testy používají,
- nedělat destruktivní zásahy mimo data vytvořená pro test.

Doporučená klíčová slova:

```text
připravím kurz "AUTO_TEST_VOLNY_KURZ" s kapacitou 10 a deadlinem zítra
připravím kurz "AUTO_TEST_PO_DEADLINE" s kapacitou 10 a deadlinem včera
připravím plně obsazený kurz "AUTO_TEST_PLNY_KURZ" s kapacitou 1
odstraním testovací data s prefixem "AUTO_TEST_"
```

Databázové operace mohou být řešené například:

- SQL skripty v adresářích `db/setup` a `db/teardown`,
- Python knihovnou `python-oracledb`,
- Robot Framework klíčovými slovy, která SQL skripty spouštějí,
- nebo REST endpointy určenými pouze pro testovací prostředí.

---

## 4. Proof of concept testy

Vytvořte minimálně tyto testovací scénáře.

### Test 1: Přihlášení a otevření stránky

```gherkin
Scénář: Uživatel se dostane na povolenou stránku
  Pokud jsem přihlášen jako "user_a"
  Když otevřu stránku "Přehled"
  Pak jsem na stránce "Přehled"
  A zároveň vidím text "Přehled"
```

### Test 2: Kontrola interactive gridu

```gherkin
Scénář: Uživatel vidí očekávaný interactive grid
  Pokud jsem přihlášen jako "user_a"
  Když otevřu stránku "Přihlášky"
  Pak vidím interactive grid "Přehled přihlášek"
  A zároveň grid "Přehled přihlášek" obsahuje sloupce:
    | Název sloupce |
    | Jméno         |
    | Příjmení      |
    | Stav          |
```

### Test 3: Uživatel může editovat záznamy

```gherkin
Scénář: Oprávněný uživatel může upravovat grid
  Pokud jsem přihlášen jako "admin"
  Když otevřu stránku "Přihlášky"
  Pak grid "Přehled přihlášek" je editovatelný
```

### Test 4: Uživatel nesmí editovat záznamy

```gherkin
Scénář: Běžný uživatel nemůže upravovat grid
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Přihlášky"
  Pak grid "Přehled přihlášek" není editovatelný
```

### Test 5: Kontrola bočního menu

```gherkin
Scénář: Uživatel vidí pouze povolené položky menu
  Pokud jsem přihlášen jako "student"
  Když otevřu stránku "Domů"
  Pak v bočním menu vidím položku "Přihlášky"
  Ale v bočním menu nevidím položku "Administrace"
```

### Test 6: Přihláška na sportovní kurz přes formulář a ověření v gridu

Tento test má ověřit reálnější business flow: student vyplní přihlášku na sportovní kurz, formulář odešle a následně ve svém přehledu přihlášek uvidí odpovídající řádek.

```gherkin
Scénář: Student se přihlásí na volný kurz před deadlinem
  Pokud odstraním testovací data s prefixem "AUTO_TEST_"
  A zároveň připravím kurz "AUTO_TEST_VOLNY_KURZ" s kapacitou 10 a deadlinem zítra
  A zároveň jsem přihlášen jako "student"
  Když otevřu stránku "Přihláška na sportovní kurz"
  A zároveň ve formuláři "Přihláška na kurz" vyplním hodnoty:
    | Položka  | Hodnota               |
    | Kurz     | AUTO_TEST_VOLNY_KURZ  |
    | Poznámka | Test běžné přihlášky  |
  A zároveň odešlu formulář "Přihláška na kurz"
  Pak jsem na stránce "Moje přihlášky"
  A zároveň v interactive gridu "Moje přihlášky" vidím řádek s hodnotami:
    | Sloupec  | Hodnota               |
    | Kurz     | AUTO_TEST_VOLNY_KURZ  |
    | Stav     | Přihlášen             |
    | Poznámka | Test běžné přihlášky  |
  A zároveň odstraním testovací data s prefixem "AUTO_TEST_"
```

Další povinné varianty tohoto scénáře:

```gherkin
Scénář: Student je po překročení deadlinu přihlášen jako náhradník
  Pokud odstraním testovací data s prefixem "AUTO_TEST_"
  A zároveň připravím kurz "AUTO_TEST_PO_DEADLINE" s kapacitou 10 a deadlinem včera
  A zároveň jsem přihlášen jako "student"
  Když otevřu stránku "Přihláška na sportovní kurz"
  A zároveň ve formuláři "Přihláška na kurz" vyplním hodnoty:
    | Položka | Hodnota                |
    | Kurz    | AUTO_TEST_PO_DEADLINE  |
  A zároveň odešlu formulář "Přihláška na kurz"
  Pak jsem na stránce "Moje přihlášky"
  A zároveň v interactive gridu "Moje přihlášky" vidím řádek s hodnotami:
    | Sloupec | Hodnota                |
    | Kurz    | AUTO_TEST_PO_DEADLINE  |
    | Stav    | Náhradník              |
  A zároveň odstraním testovací data s prefixem "AUTO_TEST_"
```

```gherkin
Scénář: Student je po naplnění kapacity kurzu přihlášen jako náhradník
  Pokud odstraním testovací data s prefixem "AUTO_TEST_"
  A zároveň připravím plně obsazený kurz "AUTO_TEST_PLNY_KURZ" s kapacitou 1
  A zároveň jsem přihlášen jako "student"
  Když otevřu stránku "Přihláška na sportovní kurz"
  A zároveň ve formuláři "Přihláška na kurz" vyplním hodnoty:
    | Položka | Hodnota              |
    | Kurz    | AUTO_TEST_PLNY_KURZ  |
  A zároveň odešlu formulář "Přihláška na kurz"
  Pak jsem na stránce "Moje přihlášky"
  A zároveň v interactive gridu "Moje přihlášky" vidím řádek s hodnotami:
    | Sloupec | Hodnota              |
    | Kurz    | AUTO_TEST_PLNY_KURZ  |
    | Stav    | Náhradník            |
  A zároveň odstraním testovací data s prefixem "AUTO_TEST_"
```

Poznámka: Úklid dat by měl být technicky řešen jako teardown, aby proběhl i v případě, že test selže. V textu scénáře je uveden kvůli čitelnosti požadovaného flow.

---

# Monitoring výsledků

Testy nesmí pouze vypsat výsledek do konzole. Musí vzniknout návrh, jak výsledky sledovat dlouhodobě.

Požadovaný minimální výstup:

1. každý testovací běh má vlastní `run_id`,
2. ukládá se datum a čas spuštění,
3. ukládá se název testované aplikace,
4. ukládá se prostředí, například `DEV`, `TEST`, `PROD`,
5. ukládá se výsledek každého scénáře,
6. ukládá se chybová zpráva u neúspěšného testu,
7. ukládá se screenshot při selhání,
8. výsledky je možné zobrazit v APEX stránce.

Doporučený datový model:

```sql
TEST_RUN
- id
- app_name
- environment
- started_at
- finished_at
- status
- total_tests
- passed_tests
- failed_tests
- triggered_by

TEST_CASE_RESULT
- id
- test_run_id
- suite_name
- test_name
- status
- started_at
- finished_at
- duration_ms
- error_message
- screenshot_blob
- log_clob
```

Možné technické řešení:

- Robot Framework vygeneruje výsledky do XML/JSON,
- Python skript výsledky přečte,
- Python skript je odešle do APEX aplikace přes REST endpoint,
- APEX aplikace zobrazí přehled testovacích běhů.

Dashboard v APEX by měl obsahovat minimálně:

- seznam běhů testů,
- celkový stav běhu,
- počet prošlých a neprošlých testů,
- detail konkrétního testu,
- chybovou hlášku,
- screenshot chyby nebo log.

---

# Rozdělení práce v týmu

Studenti pracují jako jeden tým, ale každý by měl mít jasnou odpovědnost.

## Student 1: Architektura, UI automatizace, selektory

Vhodné vzhledem ke zkušenostem s HTML, CSS, JS, Pythonem, Tauri a Godotem.

Odpovědnosti:

- navrhnout strukturu projektu,
- prozkoumat DOM APEX aplikace,
- vybrat stabilní selektory,
- navrhnout způsob hledání regionů, gridů a menu,
- implementovat základní browser flow,
- připravit dokumentaci architektury,
- průběžně doplňovat `system_overview.md` a ADR k architektonickým rozhodnutím.

Výstupy:

- `architecture.md`,
- `selectors.md`,
- `system_overview.md`,
- základní browser test otevření aplikace,
- návrh obecných pravidel pro psaní selektorů.

---

## Student 2: Gherkin scénáře a klíčová slova

Vhodné vzhledem ke znalosti Pythonu, HTML, CSS a desktop platformy.

Odpovědnosti:

- připravit testovací scénáře,
- navrhnout srozumitelná česká klíčová slova,
- implementovat resource soubory Robot Frameworku,
- otestovat čitelnost scénářů,
- připravit návod pro psaní dalších testů,
- doplňovat deník práce `worklog.md`.

Výstupy:

- `prihlaseni.robot`,
- `interactive_grid.robot`,
- `menu.robot`,
- `apex_klicova_slova.resource`,
- `how_to_write_tests.md`,
- části `typical_workflow.md` popisující přidání nového testu.

---

## Student 3: Reporting, zpracování výsledků, monitoring

Vhodné vzhledem ke zkušenostem s Pythonem, pygame, NumPy a předchozími projekty.

Odpovědnosti:

- zpracovat výstupy testů,
- navrhnout datový model výsledků,
- připravit Python parser výsledků,
- připravit odesílání výsledků do APEX / REST endpointu,
- navrhnout jednoduchý monitoring dashboard,
- připravit databázový setup/teardown pro testovací scénáře s přihláškami na sportovní kurzy.

Výstupy:

- `parse_results.py`,
- `send_results_to_apex.py`,
- `result_schema.md`,
- návrh tabulek pro výsledky,
- ukázkový JSON payload testovacího běhu,
- SQL nebo Python skripty pro přípravu a úklid testovacích dat,
- ADR k přístupu k testovacím datům.

---

# Harmonogram na přibližně 7,5 pracovního dne

Reálně je k dispozici přibližně 7,5 dne práce. Tomu musí odpovídat rozsah proof of conceptu. Cílem není dokončit produkční testovací platformu, ale vytvořit funkční, dokumentovaný a rozšiřitelný základ.

## Den 1: Seznámení s úkolem, prostředím a APEX aplikací

Cíl:

- pochopit účel testované APEX aplikace,
- spustit vývojové prostředí,
- ověřit přístup do aplikace a testovací databáze,
- založit repozitář,
- rozdělit role v týmu,
- založit `docs/worklog.md`.

Výstupy:

- funkční lokální prostředí,
- první ručně popsané testovací scénáře,
- ověřené přístupy,
- první zápis v deníku práce.

---

## Den 2: Analýza UI, selektorů a testovaných flow

Cíl:

- najít stabilní identifikátory stránek, regionů, gridů, formulářů a menu,
- popsat, jak se budou prvky vyhledávat,
- určit minimální sadu testovaných scénářů,
- začít dokumentovat architekturu.

Výstupy:

- `docs/analysis.md`,
- `docs/selectors.md`,
- seznam testovaných stránek,
- seznam testovaných gridů a formulářů,
- první ADR k volbě testovacího stacku nebo selektorů.

---

## Den 3: Základní automatizace prohlížeče a česká BDD vrstva

Cíl:

- otevřít APEX aplikaci automatizovaně,
- přihlásit uživatele,
- přejít na konkrétní stránku,
- ověřit text na stránce,
- vytvořit první česká klíčová slova.

Výstupy:

- první spustitelný test,
- `tests/prihlaseni.robot`,
- `tests/navigace.robot`,
- základní klíčová slova pro přihlášení a navigaci,
- část `docs/how_to_write_tests.md`.

---

## Den 4: Interactive grid, menu a oprávnění

Cíl:

- detekovat interactive grid,
- ověřit názvy sloupců,
- ověřit editovatelnost/needitovatelnost,
- kontrolovat položky bočního menu,
- porovnat chování alespoň dvou rolí uživatelů.

Výstupy:

- `resources/grid_klicova_slova.resource`,
- `resources/menu_klicova_slova.resource`,
- test kontroly sloupců,
- test kontroly editovatelnosti,
- test menu pro alespoň dva uživatele.

---

## Den 5: Formulářové flow a databázový setup/teardown

Cíl:

- připravit test vyplnění formuláře a ověření výsledku v gridu,
- připravit testovací kurz s volnou kapacitou,
- připravit kurz po deadlinu,
- připravit plně obsazený kurz,
- vyřešit úklid testovacích dat.

Výstupy:

- `tests/formulare_prihlasky.robot`,
- `resources/formular_klicova_slova.resource`,
- `resources/databaze_klicova_slova.resource`,
- SQL/Python skripty v `db/setup` a `db/teardown`,
- ADR k práci s databází v testovacím prostředí.

---

## Den 6: Reporting výsledků a návrh APEX dashboardu

Cíl:

- zpracovat výstupy z Robot Frameworku,
- navrhnout strukturu výsledků,
- připravit parser výsledků,
- navrhnout payload pro odeslání výsledků,
- navrhnout APEX stránku pro monitoring.

Výstupy:

- `reporting/parse_results.py`,
- `reporting/send_results_to_apex.py` alespoň jako proof of concept nebo návrh,
- `reporting/result_schema.md`,
- návrh tabulek pro výsledky,
- návrh obrazovky v APEX.

---

## Den 7: Integrace, stabilizace a dokumentace

Cíl:

- propojit testy, databázový setup/teardown, reporting a dokumentaci,
- odstranit nejkřehčí selektory,
- doplnit screenshoty při chybě,
- doplnit dokumenty `system_overview.md`, `typical_workflow.md` a `worklog.md`,
- připravit demo scénář.

Výstupy:

- stabilní proof of concept,
- spustitelná sada testů,
- screenshot při selhání,
- dokumentovaný postup spuštění,
- aktualizované ADR záznamy,
- kompletní deník práce.

---

## Den 7,5: Prezentace výsledku a předání

Cíl:

- předvést funkční proof of concept,
- vysvětlit architekturu,
- ukázat výsledky testů,
- ukázat formulářový scénář s databázovou přípravou,
- popsat limity a doporučení dalšího rozvoje.

Výstupy:

- finální repozitář,
- `README.md`,
- krátké demo,
- seznam známých omezení,
- návrh dalšího rozvoje.

---

# Akceptační kritéria

Výsledek bude považován za splněný, pokud tým dodá:

1. spustitelný testovací projekt,
2. alespoň 5 ukázkových BDD scénářů v češtině,
3. vlastní klíčová slova pro APEX aplikaci,
4. test přihlášení za různé uživatele,
5. test dostupnosti stránky,
6. test interactive gridu a jeho sloupců,
7. test editovatelnosti / needitovatelnosti gridu,
8. test statického obsahu,
9. test bočního menu,
10. návrh ukládání výsledků testů,
11. parser testovacích výsledků,
12. návrh APEX monitorovací stránky,
13. dokumentaci ke spuštění,
14. dokumentaci k psaní dalších testů,
15. test formulářového flow: vyplnění formuláře, odeslání a ověření řádku v interactive gridu,
16. databázový setup a teardown pro testovací data,
17. scénář pro kurz po deadlinu, kde se student stane náhradníkem,
18. scénář pro plný kurz, kde se student stane náhradníkem,
19. deník práce `docs/worklog.md`,
20. alespoň několik ADR záznamů v `docs/adr`,
21. dokument `docs/system_overview.md`,
22. dokument `docs/typical_workflow.md`.

---

# Důležitá technická pravidla

## Selektory

Nepoužívejte křehké selektory typu:

```css
div:nth-child(4) > span:nth-child(2)
```

Preferujte:

- stabilní ID prvků,
- statické ID APEX regionů,
- `data-*` atributy, pokud je lze do aplikace doplnit,
- názvy regionů,
- textové labely,
- role a accessible name, pokud jsou dostupné.

U APEX aplikací může být DOM dynamický, zejména u interactive gridů, modal dialogů a komponent generovaných JavaScriptem. Automatizace proto musí počítat s čekáním na prvky, ne pouze s pevným `sleep`.

---

## Konfigurace

Citlivé údaje nepatří do repozitáře.

Soubor `.env.example` může obsahovat například:

```env
APEX_BASE_URL=https://example.com/ords/r/app/test
APEX_ENV=TEST

APEX_USER_ADMIN=
APEX_PASSWORD_ADMIN=

APEX_USER_STUDENT=
APEX_PASSWORD_STUDENT=

RESULT_API_URL=https://example.com/ords/test-results/runs
RESULT_API_TOKEN=

TEST_DB_USER=
TEST_DB_PASSWORD=
TEST_DB_DSN=
```

Reálné hodnoty musí být v lokálním `.env`, který nebude commitovaný.

---

## Dokumentace

Dokumentace je součástí výsledku praxe, ne doplněk až na konec. Cílem není jen předvést, že testy jednou proběhly, ale zanechat po sobě řešení, které bude možné pochopit, opravit a rozšířit i po skončení praxe. Proto průběžně dokumentujte nejen hotový stav, ale i cestu, kterou jste se k němu dostali.

README musí obsahovat:

```text
1. Co projekt dělá
2. Jaké technologie používá
3. Jak nainstalovat závislosti
4. Jak nastavit .env
5. Jak spustit testy
6. Jak zobrazit výsledky
7. Jak přidat nový test
8. Jak funguje databázový setup a teardown
9. Jak je navržen monitoring výsledků
10. Známá omezení
```

Kromě README vytvořte a průběžně udržujte také tyto dokumenty:

```text
docs/worklog.md
docs/system_overview.md
docs/typical_workflow.md
docs/adr/0001-volba-testovaciho-stacku.md
docs/adr/0002-strategie-selektoru.md
docs/adr/0003-prace-s-testovacimi-daty.md
```

### Deník práce `docs/worklog.md`

Deník práce slouží k evidenci toho, co jste během praxe skutečně udělali. Nejde o formální výkaz práce po minutách. Má jít o stručný, ale pravidelný záznam denního postupu, problémů, rozhodnutí a otevřených otázek.

Deník je důležitý z několika důvodů:

- pomáhá zpětně pochopit, proč projekt vypadá právě takto,
- umožňuje vedoucímu praxe sledovat průběh práce i bez neustálého doptávání,
- usnadňuje předání projektu dalšímu člověku,
- pomáhá odlišit, co je hotové, co je pouze navržené a co zůstalo jako známé omezení,
- nutí tým průběžně formulovat problémy a neodkládat vše až na závěrečnou prezentaci.

Doporučená struktura denního zápisu:

```markdown
## 2026-xx-xx

### Co jsme dnes udělali
- ...

### Co jsme zjistili
- ...

### Jaká rozhodnutí jsme udělali
- ...

### Problémy a rizika
- ...

### Co zkusíme příště
- ...
```

Zápisy mají být věcné. Není potřeba psát dlouhé odstavce, ale musí být jasné, na čem tým pracoval a jaký to mělo výsledek. Pokud se během dne něco nepovedlo, zapište i to. Neúspěšný pokus je užitečná informace, pokud je jasné, co bylo vyzkoušeno a proč to nefungovalo.

### Architecture Decision Records `docs/adr`

ADR znamená **Architecture Decision Record**. Je to krátký záznam technického nebo architektonického rozhodnutí. Smyslem ADR není psát dlouhou dokumentaci, ale zachytit důležitá rozhodnutí ve chvíli, kdy vznikají.

V projektu budou vznikat rozhodnutí typu:

- jak se budou hledat APEX regiony a interactive gridy,
- jestli se testovací data budou připravovat přes SQL, Python, nebo REST endpoint,
- jak bude vypadat struktura vlastních klíčových slov,
- jak budou testy ukládat výsledky,
- jak se budou řešit screenshoty a logy při selhání.

U takových rozhodnutí nestačí znát jen výsledek. Důležité je i to, jaké alternativy byly zvažovány a proč byly odmítnuty. To pomůže později, až někdo narazí na omezení zvoleného řešení a bude zvažovat jeho změnu.

Doporučená struktura ADR:

```markdown
# ADR 0001: Volba testovacího stacku

## Stav
Přijato

## Kontext
Potřebujeme automatizovat testování Oracle APEX aplikace. Testy mají být čitelné, rozšiřitelné a zapisované v BDD stylu.

## Rozhodnutí
Použijeme Robot Framework s Browser Library.

## Zvažované alternativy
- Přímý Playwright v Pythonu
- Selenium
- Ruční testovací checklisty

## Důsledky
Pozitivní:
- Testy lze zapisovat pomocí vlastních klíčových slov.
- BDD styl je čitelný i mimo vývojový tým.

Negativní:
- Je nutné naučit se Robot Framework syntaxi.
- Browser Library přidává závislost na Node.js a Playwrightu.
```

ADR pište jen pro rozhodnutí, která mají dopad na podobu systému. Není potřeba vytvářet ADR pro každou drobnou úpravu kódu.

### `docs/system_overview.md`

Tento dokument má vysvětlit, jak systém funguje jako celek. Měl by popsat hlavní části řešení a vztahy mezi nimi:

- testovací scénáře,
- vlastní Robot Framework klíčová slova,
- konfiguraci aplikace a uživatelů,
- browser automatizaci,
- databázový setup/teardown,
- zpracování výsledků,
- odesílání výsledků do APEX,
- monitorovací dashboard.

Po přečtení tohoto dokumentu by měl nový člověk pochopit, kudy tečou data a co se stane při spuštění testů.

### `docs/typical_workflow.md`

Tento dokument má popsat běžný pracovní postup. Zaměřte se hlavně na praktické scénáře:

- jak spustit existující testy,
- jak přidat nový testovací scénář,
- jak přidat nové klíčové slovo,
- jak přidat nový testovací kurz nebo jiná testovací data,
- jak vyhodnotit neúspěšný test,
- kde najít screenshoty, logy a výsledky běhu,
- jak poznat, že chyba je v testu, datech, nebo v samotné APEX aplikaci.

### Doporučení k používání AI

Pro konzultace můžete používat AI nástroje. Můžou pomoci s vysvětlením neznámého pojmu, návrhem struktury dokumentace, kontrolou chyb nebo porovnáním možných přístupů. Berte je ale jako konzultační pomůcku, ne jako náhradu vlastní práce.

Jste na praxi proto, abyste se zlepšili v analýze problému, hledání informací, návrhu řešení, ladění a ověřování výsledků. Proto se snažte maximum věcí dělat ručně: projít dokumentaci, vyzkoušet selektory v DevTools, spustit testy, přečíst chybové hlášky, dohledat příčinu a teprve potom si případně nechat poradit. Výsledek, kterému nerozumíte, není dobrý výsledek ani v případě, že zrovna funguje.

---

# Software potřebný na počítačích

## Povinný software

### 1. Python

Doporučení: aktuální stabilní Python 3.11 nebo novější.

Použití:

- Robot Framework,
- parser výsledků,
- odesílání výsledků do APEX,
- pomocné skripty.

---

### 2. pip a virtualenv / venv

Použití:

- instalace Python balíčků,
- izolace závislostí projektu.

Příklad:

```bash
python -m venv .venv
source .venv/bin/activate      # Linux/macOS
.venv\Scripts\activate         # Windows
pip install -r requirements.txt
```

---

### 3. Robot Framework

Použití:

- zápis a spouštění testovacích scénářů,
- tvorba vlastních klíčových slov,
- generování reportů.

---

### 4. Robot Framework Browser Library

Použití:

- ovládání prohlížeče,
- klikání,
- vyplňování formulářů,
- ověřování viditelnosti prvků,
- testování APEX UI.

---

### 5. Node.js

Použití:

- nutné pro Browser Library / Playwright část,
- instalace browser závislostí přes `rfbrowser init`.

---

### 6. Playwright browsers

Použití:

- Chromium,
- Firefox,
- WebKit podle potřeby.

Pro proof of concept stačí Chromium.

---

### 7. Git

Použití:

- verzování,
- týmová spolupráce,
- code review,
- historie změn.

---

### 8. Visual Studio Code

Použití:

- vývoj testů,
- editace Pythonu,
- editace `.robot` souborů,
- práce s Gitem.

Doporučená rozšíření:

- Python,
- Robot Framework Language Server,
- YAML,
- GitLens,
- Playwright Test for VS Code, pokud se bude používat i přímý Playwright.

---

### 9. Webový prohlížeč

Doporučení:

- Google Chrome nebo Chromium,
- Firefox jako doplňkový prohlížeč.

Použití:

- ruční analýza aplikace,
- DevTools,
- ověřování selektorů.

---

### 10. Přístup do izolované testovací databáze

Studenti budou potřebovat řízený přístup do testovací Oracle databáze, aby mohli připravovat a uklízet testovací data. Tento přístup má být určen pouze pro izolované testovací prostředí.

Použití:

- vytvoření testovacích kurzů,
- nastavení deadlinu kurzu,
- nastavení kapacity kurzu,
- vytvoření obsazeného kurzu,
- úklid testovacích přihlášek a pomocných dat.

---

### 11. Přístup do testované APEX aplikace

Studenti budou potřebovat:

- URL testované APEX aplikace,
- testovací uživatele,
- hesla nebo jiný bezpečný způsob přihlášení,
- popis očekávaných rolí,
- seznam testovaných stránek,
- seznam očekávaných menu položek,
- seznam očekávaných interactive gridů a sloupců.

---

## Doporučený software

### 12. SQL Developer nebo SQLcl

Použití:

- návrh tabulek pro ukládání výsledků,
- kontrola dat,
- ladění REST endpointů,
- práce s Oracle databází.

---

### 13. Oracle APEX vývojové prostředí

Použití:

- vytvoření monitorovací stránky,
- zobrazení výsledků testů,
- návrh dashboardu,
- případně vytvoření REST endpointu přes ORDS.

---

### 14. ORDS / REST endpoint dostupný pro výsledky

Použití:

- příjem výsledků testů,
- zápis do tabulek,
- propojení testovacího runneru s APEX dashboardem.

---

### 15. Postman nebo Insomnia

Použití:

- testování REST endpointu,
- ladění payloadu výsledků,
- kontrola autorizace.

---

### 15. Docker Desktop nebo Podman

Není nutné, ale vhodné.

Použití:

- sjednocené vývojové prostředí,
- případné spuštění test runneru v kontejneru,
- budoucí CI integrace.

---

# Doporučený `requirements.txt`

```text
robotframework
robotframework-browser
python-dotenv
requests
pyyaml
lxml
python-oracledb
```

Volitelně:

```text
pytest
pydantic
rich
```

---

# Doporučené instalační příkazy

Linux/macOS:

```bash
python -m venv .venv
source .venv/bin/activate

pip install --upgrade pip
pip install robotframework robotframework-browser python-dotenv requests pyyaml lxml python-oracledb

rfbrowser init
```

Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\activate

pip install --upgrade pip
pip install robotframework robotframework-browser python-dotenv requests pyyaml lxml python-oracledb

rfbrowser init
```

---

# Doporučení pro proof of concept

Rozsah držte přiměřený přibližně 7,5 pracovního dne. Hlavní hodnota nemá být v množství testů, ale v tom, že vznikne rozšiřitelný základ:

- jasná architektura,
- čitelná česká BDD syntaxe,
- několik funkčních APEX klíčových slov,
- ukázkové testy,
- reporting,
- návrh APEX dashboardu.

Za úspěšný výsledek lze považovat stav, kdy po skončení praxe bude možné přidat nový test například takto:

```gherkin
Scénář: Referent vidí administraci přihlášek
  Pokud jsem přihlášen jako "referent"
  Když otevřu stránku "Administrace přihlášek"
  Pak vidím interactive grid "Přihlášky"
  A zároveň grid "Přihlášky" obsahuje sloupce:
    | Název sloupce |
    | Student       |
    | Soutěž        |
    | Stav          |
  A zároveň grid "Přihlášky" je editovatelný
  A zároveň v bočním menu vidím položku "Administrace"
```

Autor nového testu by přitom neměl znovu řešit nízkoúrovňové klikání, čekání na prvky a strukturu APEX DOMu. Tyto technické detaily mají být zakryté vlastními klíčovými slovy testovacího frameworku.

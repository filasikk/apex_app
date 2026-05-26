*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Resource    ../resources/grid_klicova_slova.resource
Resource    ../resources/spolecne.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel ověří sloupce v Interactive Gridu "Seznam zaměstnanců s emailem"
    Když se přihlásím jako "admin"
    Když otevřu stránku "Seznam zaměstnanců s emailem"
    Pak vidím interactive grid "Seznam zaměstnanců s emailem"
    A zároveň grid "Seznam zaměstnanců s emailem" obsahuje sloupce
    ...    Osobní číslo
    ...    Jméno
    ...    Příjmení
    ...    Titul před
    ...    Titul za
    ...    Rodné číslo
    ...    Státní příslušnost
    ...    Místo narození
    ...    Stát narození
    ...    Rodné příjmení
    ...    Pracovní e-mail
    ...    Nastup
    ...    Pojistny Pomer Od
    ...    Konec doby určité
    ...    Adr Ulice
    ...    Adr Cislo
    ...    Adr Obec
    ...    Adr Psc

Uživatel ověří navigaci a sloupce v aplikaci
    Když se přihlásím jako "admin"
    # Zkontrolujeme, jestli levé menu obsahuje správné položky!
    Pak boční menu by mělo obsahovat položky
    ...    Personalistika přehled
    ...    Seznam zaměstnanců s emailem
    ...    Dostupné formuláře
    ...    Home

    # Pokračujeme navigací
    Když otevřu stránku "Seznam zaměstnanců s emailem"
    Pak vidím interactive grid "Seznam zaměstnanců s emailem"

####################################################
Role vedoucí by měla vidět všechny sloupce a kompletní menu
    Když se přihlásím jako "admin"
    Když otevřu stránku "Seznam zaměstnanců s emailem"

    # Kontrola všech sloupců (včetně Rodného příjmení)
    Pak mřížka by měla obsahovat sloupce
    ...    Osobní číslo
    ...    Jméno
    ...    Příjmení
    ...    Titul před
    ...    Titul za
    ...    Rodné číslo
    ...    Státní příslušnost
    ...    Místo narození
    ...    Stát narození
    ...    Rodné příjmení
    ...    Pracovní e-mail
    ...    Nastup
    ...    Pojistny Pomer Od
    ...    Konec doby určité
    ...    Adr Ulice
    ...    Adr Cislo
    ...    Adr Obec
    ...    Adr Psc

Role nevedoucí by NEMĚLA vidět Rodné číslo a mít menší menu
    Když se přihlásím jako "admin"
    Změň roli přes formulář a ověř editovatelnost    S_ROLI_NEVEDOUCI

    Když otevřu stránku "Seznam zaměstnanců s emailem"

    # Zkontrolujeme sloupce, kde chybí Rodné číslo
    Pak mřížka by měla obsahovat sloupce
    ...    Osobní číslo
    ...    Jméno
    ...    Příjmení
    ...    Titul před
    ...    Titul za
    ...    Státní příslušnost
    ...    Místo narození
    ...    Stát narození
    ...    Rodné příjmení
    ...    Pracovní e-mail
    ...    Nastup
    ...    Pojistny Pomer Od
    ...    Konec doby určité
    ...    Adr Ulice
    ...    Adr Cislo
    ...    Adr Obec
    ...    Adr Psc

    Pak mřížka by NEMĚLA obsahovat sloupec    Rodné číslo

    # Na konci se vrátíme na admina
    Vrať roli zpět na admina

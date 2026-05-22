*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Resource    ../resources/grid_klicova_slova.resource
Resource    ../resources/spolecne.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel ověří sloupce v Interactive Gridu "Seznam zaměstnanců s emailem"
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    Sleep    1s
    A zároveň kliknu na položku v menu "Personalistika přehled"
    Sleep    1s
    Sleep    1s
    A zároveň kliknu na položku v menu "Seznam zaměstnanců s emailem"
    Sleep    1s
    Wait For Elements State    text="Osobní číslo" >> nth=0    visible    timeout=15s
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

Uživatel ověří navigaci a sloupce v aplikaci
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu

    # 1. Zkontrolujeme, jestli levé menu obsahuje správné položkyyy!
    Pak boční menu by mělo obsahovat položky
    ...    Personalistika přehled
    ...    Seznam zaměstnanců s emailem
    ...    Dostupné formuláře
    ...    Home

    # 2. Pak normálně pokračujeme klikáním...
    A zároveň kliknu na položku v menu "Personalistika přehled"
    A zároveň kliknu na položku v menu "Seznam zaměstnanců s emailem"

####################################################
Role vedoucí by měla vidět všechny sloupce včetně Rodného čísla
    Když se přihlásím jako "admin"  # Uprav podle svých testovacích účtů
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Personalistika přehled"
    A zároveň kliknu na položku v menu "Seznam zaměstnanců s emailem"

    Wait For Elements State    text="Osobní číslo" >> nth=0    visible    timeout=15s

    # Vedoucí vidí všechno, takže mu tam pošleme i Rodné číslo
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

Role nevedoucí by NEMĚLA vidět Rodné číslo
    # Přihlásíme se pod účtem obyčejného uživatele
    Když se přihlásím jako "nevedouci"  # Uprav podle svých testovacích účtů
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Personalistika přehled"
    A zároveň kliknu na položku v menu "Seznam zaměstnanců s emailem"

    Wait For Elements State    text="Osobní číslo" >> nth=0    visible    timeout=15s

    # Uživatel vidí základní sloupce (Rodné číslo z tohoto seznamu vynecháme!)
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

    # A teď explicitně zkontrolujeme, že ten zakázaný sloupec tam fakt nenííí!
    A zároveň mřížka by NEMĚLA obsahovat sloupec    Rodné číslo

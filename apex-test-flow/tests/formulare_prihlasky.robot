*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Resource    ../resources/spolecne.resource
Resource    ../resources/formular_klicova_slova.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Úspěšné odeslání přihlášky na kurz
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    Sleep    1s
    A zároveň kliknu na media list title    UTS - přihlášení
    Sleep    1s
    A zároveň vytvořím nový kurz    kurz s volnou kapacitou    99    30.5.2026


kurz po deadlinu
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    Sleep    1s
    A zároveň kliknu na media list title    UTS - přihlášení
    Sleep    1s
    A zároveň vytvořím nový kurz    kurz po deadlinu    99    13.5.2026

kurz s plnou kapacitou
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    Sleep    1s
    A zároveň kliknu na media list title    UTS - přihlášení
    Sleep    1s
    A zároveň vytvořím nový kurz    kurz s plnou kapacitou    1    30.5.2026
    Sleep    1s
    A zároveň kliknu na Menu
    Sleep    1s
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    Sleep    1s
    A zároveň kliknu na media list title    UTS - přihláška na kurz
    Sleep    1s
    A zároveň Přihlásím se do kurzu    kurz s plnou kapacitou

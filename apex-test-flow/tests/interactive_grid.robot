*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Resource    ../resources/grid_klicova_slova.resource
Resource    ../resources/spolecne.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel ověří sloupce v Interactive Gridu "Seznam zaměstnanců s emailem"
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Personalistika přehled"
    Sleep    1s
    A zároveň kliknu na položku v menu "Seznam zaměstnanců s emailem"
    Sleep    1s
    # Ověření názvů sloupců podle zadání a screenshotu

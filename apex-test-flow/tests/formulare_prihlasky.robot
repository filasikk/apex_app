*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Resource    ../resources/spolecne.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
kurz s volnou kapacitou
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    sleep   1s
    A zároveň kliknu na media list title    UTS - přihlášení
    sleep   1s
    Click    button:has-text("Přidat řádek") >> nth=0
    Sleep    1s
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=2
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=2 >> input    kurz s volnou kapacitou
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=4
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=4 >> input    99
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=5
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=5 >> input    30.5.2026
    Click    button:has-text("Uložit") >> nth=0

kurz po deadlinu
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    sleep   1s
    A zároveň kliknu na media list title    UTS - přihlášení
    sleep   1s
    Click    button:has-text("Přidat řádek") >> nth=0
    Sleep    1s
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=2
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=2 >> input    po deadlinu
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=4
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=4 >> input    99
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=5
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=5 >> input    13.5.2026
    Click    button:has-text("Uložit") >> nth=0

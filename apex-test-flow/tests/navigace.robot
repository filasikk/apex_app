*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel přejde na stránku Rozcestník
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    Pak vidím hlavní nadpis "Formuláře"

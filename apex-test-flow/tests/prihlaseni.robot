*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel se úspěšně přihlásí
    Když se přihlásím jako "admin"
    Pak vidím, že jsem přihlášen

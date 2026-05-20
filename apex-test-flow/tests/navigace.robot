*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel přejde na stránku App Builderu
    Když se přihlásím jako "admin"
    A zároveň kliknu na App Builder
    Pak vidím text "App Builder"

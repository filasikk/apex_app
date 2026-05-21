*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Test Setup    Otevři prohlížeč a aplikaci

*** Test Cases ***
Uživatel přejde na stránku Rozcestník
    Když se přihlásím jako "admin"
    A zároveň kliknu na Menu
    A zároveň kliknu na položku v menu "Personalistika přehled"
    A zároveň kliknu na media list title    Seznam zaměstnanců s emailem
    Wait For Elements State    h2.u-VisuallyHidden:has-text("Seznam zaměstnanců s emailem")    attached

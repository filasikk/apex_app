*** Settings ***
Resource    ../resources/prihlaseni_klicova_slova.resource
Resource    ../resources/spolecne.resource
Resource    ../resources/formular_klicova_slova.resource
Resource    ../resources/databaze_klicova_slova.resource
Test Setup       Otevři prohlížeč a aplikaci
Test Teardown    Odstraň testovací data


*** Test Cases ***
Student se přihlásí na volný kurz před deadlinem
    Pokud připravím kurz s volnou kapacitou
    Když se přihlásím jako "admin"
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    A zároveň kliknu na media list title    UTS - přihláška na kurz

    A zároveň Přihlásím se do kurzu    AUTO_TEST_VOLNY

Student je po překročení deadlinu přihlášen jako náhradník
    Pokud připravím kurz po deadlinu
    Když se přihlásím jako "admin"
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    A zároveň kliknu na media list title    UTS - přihláška na kurz

    A zároveň Přihlásím se do kurzu    AUTO_TEST_PO_DEADLINU



Student je po naplnění kapacity kurzu přihlášen jako náhradník
    Pokud připravím plně obsazený kurz
    Když se přihlásím jako "admin"
    A zároveň kliknu na položku v menu "Dostupné formuláře"
    A zároveň kliknu na media list title    UTS - přihláška na kurz

    A zároveň Přihlásím se do kurzu    AUTO_TEST_PLNY

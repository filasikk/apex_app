*** Settings ***
Resource    spolecne.resource
Variables   ../variables/env_loader.py    uzivatele.yaml

*** Keywords ***
se přihlásím jako "${role}"
    ${uzivatel}=    Set Variable    ${UZIVATELE['${role}']}
    Fill Text       id=username    ${uzivatel['jmeno']}
    Fill Text       id=password   ${uzivatel['heslo']}
    Click           [name="_eventId_proceed"]

vidím, že jsem přihlášen
    Wait For Elements State    id=t_PageBody    visible    timeout=5s

Když se přihlásím jako "${role}"
    se přihlásím jako "${role}"
    vidím, že jsem přihlášen


Pak vidím, že jsem přihlášen
    vidím, že jsem přihlášen

A zároveň otevřu stránku "${stranka}"
    otevřu stránku "${stranka}"

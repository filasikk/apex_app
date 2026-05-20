*** Settings ***
Resource    spolecne.resource
Variables    ../variables/uzivatele.example.yaml

*** Keywords ***
se přihlásím jako "${role}"
    ${uzivatel}=    Set Variable    ${UZIVATELE['${role}']}
    Fill Text       id=F4550_P1_COMPANY    ${uzivatel['workspace']}
    Fill Text       id=F4550_P1_USERNAME    ${uzivatel['jmeno']}
    Fill Text       id=F4550_P1_PASSWORD    ${uzivatel['heslo']}
    Click           id=B232005500580944564

vidím, že jsem přihlášen
    Wait For Elements State    id=R390755402636297329    visible    timeout=5s

Když se přihlásím jako "${role}"
    se přihlásím jako "${role}"

Pak vidím, že jsem přihlášen
    vidím, že jsem přihlášen

A zároveň otevřu stránku "${stranka}"
    otevřu stránku "${stranka}"

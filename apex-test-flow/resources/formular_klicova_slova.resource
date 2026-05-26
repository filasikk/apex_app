*** Keywords ***
A zároveň vytvořím nový kurz
    [Arguments]    ${nazev}    ${kapacita}    ${datum}
    Click    button:has-text("Přidat řádek") >> nth=0
    Wait For Elements State    .a-GV-row.is-inserted    visible    timeout=5s

    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=2
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=2 >> input    ${nazev}

    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=4
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=4 >> input    ${kapacita}

    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=5
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=5 >> input    ${datum}

    Click    button:has-text("Uložit") >> nth=0
    Wait For Elements State    .a-GV-row.is-inserted    hidden    timeout=5s

A zároveň Přihlásím se do kurzu
    [Arguments]    ${kurz}
    Wait For Elements State    text="Chci se přihlásit na kurz"    visible    timeout=5s

    Select Options By    xpath=//select[preceding::label[contains(text(), "Chci se přihlásit na kurz")]]    text    ${kurz}

    Click    xpath=//div[contains(@class, "t-Form-fieldContainer") and .//label[contains(text(), "zveřejněním jména")]]//span[contains(@class, "a-Switch-toggle")]
    Click    xpath=//div[contains(@class, "t-Form-fieldContainer") and .//label[contains(text(), "poučení o zpracování")]]//span[contains(@class, "a-Switch-toggle")]
    Click    xpath=//div[contains(@class, "t-Form-fieldContainer") and .//label[contains(text(), "smluvní podmínky")]]//span[contains(@class, "a-Switch-toggle")]

    Click    xpath=//label[contains(text(), "Jsem externí účastník")]

    Click    button:has-text("Přihlásit")
    Wait For Elements State    .t-Alert--success    visible    timeout=5s
    ${msg}=    Get Text    .t-Alert-content
    Log To Console    \n[APEX] Zobrazená hláška: ${msg}

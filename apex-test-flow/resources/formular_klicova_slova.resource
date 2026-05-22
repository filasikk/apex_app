*** Keywords ***
A zároveň vytvořím nový kurz
    [Arguments]    ${nazev}    ${kapacita}    ${datum}
    Click    button:has-text("Přidat řádek") >> nth=0
    Sleep    1s
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=2
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=2 >> input    ${nazev}
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=4
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=4 >> input    ${kapacita}
    Click    .a-GV-row.is-inserted .a-GV-cell >> nth=5
    Fill Text    .a-GV-row.is-inserted .a-GV-cell >> nth=5 >> input    ${datum}
    Click    button:has-text("Uložit") >> nth=0
    Sleep    1s

A zároveň Přihlásím se do kurzu
    [Arguments]    ${kurz}
    Select Options By    xpath=//select[preceding::label[contains(text(), "Chci se přihlásit na kurz")]]    text    ${kurz}

    # Selektor najde kontejner podle textu v labelu a v něm klikne na ten přepínač
    Click    xpath=//div[contains(@class, "t-Form-fieldContainer") and .//label[contains(text(), "zveřejněním jména")]]//span[contains(@class, "a-Switch-toggle")]
    Click    xpath=//div[contains(@class, "t-Form-fieldContainer") and .//label[contains(text(), "poučení o zpracování")]]//span[contains(@class, "a-Switch-toggle")]
    Click    xpath=//div[contains(@class, "t-Form-fieldContainer") and .//label[contains(text(), "smluvní podmínky")]]//span[contains(@class, "a-Switch-toggle")]

    Click    xpath=//label[contains(text(), "Jsem externí účastník")]

    Click    button:has-text("Přihlásit")
    Sleep    1s

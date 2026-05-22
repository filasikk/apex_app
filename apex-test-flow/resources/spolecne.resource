*** Settings ***
Library      Browser
Variables    ../variables/aplikace.yaml
Variables    ../variables/stranky.yaml

*** Keywords ***
Otevři prohlížeč a aplikaci
    New Browser    browser=${PROHLIZEC}    headless=${HEADLESS}
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       url=${URL_APLIKACE}

Když kliknu na Menu
    Click    id=t_Button_navControl

A zároveň kliknu na Menu
    Když kliknu na Menu

Když kliknu na položku v menu "${nazev_polozky}"
    # Uložíme si ten selektor do proměnné, ať ho nemusíme psát dvakrát
    ${selector}=    Set Variable    css=#t_TreeNav >> text="${nazev_polozky}"

    # Počkáme, až se prvek aspoň objeví v HTML kódu (ignorujeme, jestli je schovaný animací)
    Wait For Elements State    ${selector}    attached

    # Odpálíme kliknutí přímo přes JavaScript! Tím obejdeme úplně všechny překážky.
    Evaluate JavaScript    ${selector}    (elem) => elem.click()


A zároveň kliknu na položku v menu "${nazev_polozky}"
    Když kliknu na položku v menu "${nazev_polozky}"

Pak URL adresa obsahuje "${text}"
    ${url}=    Get Url
    Should Contain    ${url}    ${text}

Pak vidím hlavní nadpis "${text}"
    Wait For Elements State    .t-Region-header:has-text("${text}")    visible
    Get Text    h1    ==    ${text}

Klikni na media list title
    [Arguments]    ${jmeno}
    ${selector}=    Set Variable    css=.t-MediaList-title:has-text("${jmeno}")
    Wait For Elements State    ${selector}    visible
    Click    ${selector}

Když kliknu na media list title
    [Arguments]    ${jmeno}
    Klikni na media list title    ${jmeno}

A zároveň kliknu na media list title
    [Arguments]    ${jmeno}
    Klikni na media list title    ${jmeno}

Pak boční menu by mělo obsahovat položky
    [Arguments]    @{ocekavane_polozky}
    FOR    ${polozka}    IN    @{ocekavane_polozky}
        # Hledáme text přímo uvnitř navigačního stromu a bereme hned první výskyt, co najdemeee!
        Wait For Elements State    css=#t_TreeNav >> text="${polozka}" >> nth=0    visible    timeout=5s
    END

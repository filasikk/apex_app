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
    # Zjistíme, jestli je menu schované
    ${is_collapsed}=    Get Element Count    css=body.t-PageBody--hideLeft
    IF    ${is_collapsed} > 0
        # Klikneme na tlačítko pro otevření
        Click    id=t_Button_navControl
        # Počkáme chvíli na animaci
        Sleep    0.5s
    END
    # Pro jistotu počkáme, až bude strom navigace viditelný
    Wait For Elements State    id=t_TreeNav    visible    timeout=5s

A zároveň kliknu na Menu
    Když kliknu na Menu

Když kliknu na položku v menu "${nazev_polozky}"
    # Nejdřív zajistíme, že je menu vůbec vidět
    Když kliknu na Menu

    ${selector}=    Set Variable    xpath=//*[@id="t_TreeNav"]//*[contains(text(), "${nazev_polozky}")]
    Wait For Elements State    ${selector}    visible    timeout=10s
    Click    ${selector}


A zároveň kliknu na položku v menu "${nazev_polozky}"
    Když kliknu na položku v menu "${nazev_polozky}"

Pak URL adresa obsahuje "${text}"
    ${url}=    Get Url
    Should Contain    ${url}    ${text}

Pak vidím text
    [Arguments]    ${text}
    # Počkáme, až se text kdekoliv na stránce objeví a bude viditelný
    Wait For Elements State    text="${text}"    visible    timeout=5s

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

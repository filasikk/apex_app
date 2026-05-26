*** Settings ***
Library      Browser
Variables    ../variables/aplikace.yaml
Variables    ../variables/stranky.yaml

*** Keywords ***
Otevři prohlížeč a aplikaci
    New Browser    browser=${PROHLIZEC}    headless=${HEADLESS}
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       url=${URL_APLIKACE}

Zajisti rozbalené menu
    # V APEXu se rozbalení pozná podle třídy na body. Pokud tam je t-PageBody--hideLeft, je menu zavřené.
    ${is_collapsed}=    Get Element Count    css=body.t-PageBody--hideLeft
    IF    ${is_collapsed} > 0
        Click    id=t_Button_navControl
        # Počkáme na animaci
        Sleep    0.5s
    END

Když kliknu na Menu
    Zajisti rozbalené menu

A zároveň kliknu na Menu
    Když kliknu na Menu

Když kliknu na položku v menu "${nazev_polozky}"
    Zajisti rozbalené menu
    ${selector}=    Set Variable    css=#t_TreeNav >> text="${nazev_polozky}"
    Wait For Elements State    ${selector}    attached    timeout=10s
    # Získáme stavy a zkontrolujeme viditelnost bez vyhození chyby
    ${states}=    Get Element States    ${selector}
    ${is_visible}=    Evaluate    "visible" in $states
    IF    ${is_visible}
        Click    ${selector}
    ELSE
        Evaluate JavaScript    ${selector}    (elem) => elem.click()
    END

A zároveň kliknu na položku v menu "${nazev_polozky}"
    Když kliknu na položku v menu "${nazev_polozky}"


Když otevřu stránku "${nazev_stranky}"
    # Zkusíme jestli nejsme na Rozcestníku a tam není karta (Media List)
    ${card}=    Set Variable    css=.t-MediaList-title >> text="${nazev_stranky}"
    ${card_count}=    Get Element Count    ${card}
    IF    ${card_count} > 0
        Click    ${card}
    ELSE IF    "${nazev_stranky}" == "Domů" or "${nazev_stranky}" == "Home" or "${nazev_stranky}" == "Rozcestník"
        Go To    ${URL_APLIKACE}
    ELSE
        # Pokud nemáme kartu, zkusíme menu
        Když kliknu na položku v menu "${nazev_stranky}"
    END

otevřu stránku "${nazev_stranky}"
    Když otevřu stránku "${nazev_stranky}"


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


Změň roli přes formulář a ověř editovatelnost
    [Arguments]    ${login_uzivatele}
    # Proklikáme se na tvou novou stránku
    Když otevřu stránku "Domů"
    Když otevřu stránku "Přihlásit za uživatele"

    # --- ÚKOL 1: OVĚŘENÍ EDITOVATELNOSTI ---
    Get Element States    css=#P4_LOGIN    contains    editable

    # Role uživatele NESMÍ jít upravovat (Display Only). Zkontrolujeme, že to není editable!
    Get Element States    css=#P4_ROLE_LIST    not contains    editable

    # Vyplníme login a zmáčkneme Tab, aby se spustil ten vedoucího fix (ztráta focusu)
    Fill Text    css=#P4_LOGIN    ${login_uzivatele}
    Press Keys   css=#P4_LOGIN    Tab

    # Dáme aplikaci vteřinku na načtení rolí přes AJAX a klikneme na tlačítko
    Sleep    1s
    Click    css=button:has-text("Přihlásit za uživatele")
    Sleep    3s

Pak boční menu by mělo obsahovat položky
    [Arguments]    @{ocekavane_polozky}
    # U menu stačí že jsou v DOMu (attached), protože APEX je často schovává
    FOR    ${polozka}    IN    @{ocekavane_polozky}
        # Pokud je to Home, tak ho v menu nehledáme (je to logo nebo breadcrumb)
        IF    "${polozka}" != "Home" and "${polozka}" != "Domů"
            Wait For Elements State    css=#t_TreeNav >> text="${polozka}" >> nth=0    attached    timeout=5s
        END
    END

Vrať roli zpět na admina
    # Nejdřív se musíme dostat na tu správnou stránku s formulářem
    Když otevřu stránku "Domů"
    Když otevřu stránku "Přihlásit za uživatele"

    # Počkáme, až zmizí případná načítací clona, ať neklikneme do prázdna
    Wait For Elements State    css=.ui-widget-overlay    hidden    timeout=10s

    # Klikneme přesně na TLAČÍTKO (opět se vyhneme nadpisu stránky)
    Click    css=button:has-text("Vrátit admina")

    # Dáme APEXu chvilku na to, aby nás přehlásil zpět na admina a načetl stránku
    Sleep    3s

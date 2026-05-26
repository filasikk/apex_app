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


Změň roli přes formulář a ověř editovatelnost
    [Arguments]    ${login_uzivatele}
    # Proklikáme se na tvou novou stránku
    Když otevřu stránku "Domů"
    Když otevřu stránku "Přihlásit za uživatele"

    # Počkáme na stabilizaci stránky
    Wait For Elements State    id=P4_LOGIN    visible    timeout=10s

    # Pokud jsme už přepnutí (tlačítko 'Vrátit admina' existuje), musíme se vrátit, abychom mohli přepnout znovu
    ${reset_btn}=    Set Variable    css=button:has-text("Vrátit admina")
    ${is_switched}=    Get Element Count    ${reset_btn}
    IF    ${is_switched} > 0
        Click    ${reset_btn}
        # Po kliknutí na Vrátit admina se stránka v APEXu obvykle reloadne
        Wait For Elements State    id=P4_LOGIN    visible    timeout=10s
    END

    # --- ÚKOL 1: OVĚŘENÍ EDITOVATELNOSTI ---
    Get Element States    css=#P4_LOGIN    contains    editable

    # Role uživatele NESMÍ jít upravovat (Display Only). Zkontrolujeme, že to není editable!
    Get Element States    css=#P4_ROLE_LIST    not contains    editable

    # Vyplníme login a zmáčkneme Tab, aby se spustil ten vedoucího fix (ztráta focusu)
    Fill Text    css=#P4_LOGIN    ${login_uzivatele}
    Press Keys   css=#P4_LOGIN    Tab

    # Dáme aplikaci čas na načtení rolí přes AJAX a na to, aby se tlačítko 'Přihlásit' objevilo v DOMu
    Wait For Elements State    css=#P4_ROLE_LIST:not(:empty)    visible    timeout=10s
    Sleep    2s

    # APEX tlačítka mají často specifické ID nebo text. Zkusíme kombinaci.
    ${login_btn}=    Set Variable    css=button:has-text("Přihlásit za uživatele")
    Wait For Elements State    ${login_btn}    visible    timeout=10s
    Click    ${login_btn}

    # Počkáme na potvrzení přepnutí (stránka se reloadne nebo se objeví hláška)
    Sleep    3s


Pak boční menu by mělo obsahovat položky
    [Arguments]    @{ocekavane_polozky}
    # U menu zajistíme rozbalení postranního panelu
    Zajisti rozbalené menu
    FOR    ${polozka}    IN    @{ocekavane_polozky}
        IF    "${polozka}" == "Home" or "${polozka}" == "Domů"
            CONTINUE
        END

        # Zkusíme najít položku. Pokud není vidět, zkusíme rozbalit všechny rodiče (typické pro APEX TreeView)
        ${selector}=    Set Variable    css=#t_TreeNav >> text="${polozka}" >> nth=0
        ${count}=    Get Element Count    ${selector}

        IF    ${count} == 0
            # Pokud ji nevidíme vůbec, zkusíme rozbalit všechny složky v menu
            ${toggles}=    Get Elements    css=#t_TreeNav .a-TreeView-toggle
            FOR    ${toggle}    IN    @{toggles}
                ${is_expanded}=    Get Element States    ${toggle}    contains    expanded
                # Note: 'expanded' state check depends on implementation, sometimes it's a class or aria-expanded
                # Pro jistotu jen klikneme na všechno, co vypadá jako zavřená složka
                Click    ${toggle}
            END
            Sleep    0.5s
        END

        # Teď už by tam měla být aspoň v DOMu
        Wait For Elements State    ${selector}    attached    timeout=5s
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

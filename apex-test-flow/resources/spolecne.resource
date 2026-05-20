*** Settings ***
Library    Browser
Variables    ../variables/aplikace.yaml
Variables    ../variables/stranky.yaml

*** Keywords ***
Otevři prohlížeč a aplikaci
    New Browser    browser=${PROHLIZEC}    headless=${HEADLESS}
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       url=${URL_APLIKACE}

otevřu stránku "${stranka}"
    ${id_stranky}=    Set Variable    ${${stranka}}
    Go To    ${URL_APLIKACE}&p=${id_stranky}

vidím text "${text}"
    Wait For Elements State    text="${text}"    visible    timeout=5s

Když otevřu stránku "${stranka}"
    otevřu stránku "${stranka}"

Pak vidím text "${text}"
    vidím text "${text}"
Když kliknu na App Builder
    Click    id=a_Header_menu_0i

A zároveň kliknu na App Builder
    Když kliknu na App Builder

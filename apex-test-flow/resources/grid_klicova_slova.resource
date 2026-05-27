*** Settings ***
Library    Browser
Library    Collections

*** Keywords ***
Pak vidím interactive grid "${nazev_gridu}"
    Wait For Elements State    text="${nazev_gridu}" >> nth=0    attached    timeout=15s
    Wait For Elements State    css=.a-GV, .a-IRR-container, .t-Report, table >> nth=0    visible    timeout=15s

A zároveň grid "${nazev_gridu}" obsahuje sloupce
    [Arguments]    @{ocekavane_sloupce}
    FOR    ${sloupec}    IN    @{ocekavane_sloupce}
        Wait For Elements State    text="${sloupec}" >> nth=0    attached    timeout=5s
    END

Pak mřížka by měla obsahovat sloupce
    [Arguments]    @{ocekavane_sloupce}
    FOR    ${sloupec}    IN    @{ocekavane_sloupce}
        Wait For Elements State    text="${sloupec}" >> nth=0    attached    timeout=5s
    END

A zároveň mřížka by měla obsahovat sloupce
    [Arguments]    @{ocekavane_sloupce}
    Pak mřížka by měla obsahovat sloupce    @{ocekavane_sloupce}

Mřížka by měla mít přesně tyto sloupce
    [Arguments]    @{ocekavane_sloupce}
    ${aktualni_sloupce}=    Get Elements    .a-GV-headerLabel
    ${texty}=    Create List
    FOR    ${el}    IN    @{aktualni_sloupce}
        ${t}=    Get Text    ${el}
        IF    "${t}" != ""
            ${t_clean}=    Evaluate    " ".join("${t}".split())
            Append To List    ${texty}    ${t_clean}
        END
    END
    Lists Should Be Equal    ${texty}    ${ocekavane_sloupce}

Pak mřížka by NEMĚLA obsahovat sloupec
    [Arguments]    ${sloupec}
    Wait For Elements State    xpath=(//th[contains(normalize-space(.), "${sloupec}")] | //span[contains(normalize-space(.), "${sloupec}")])[1]    hidden    timeout=3s

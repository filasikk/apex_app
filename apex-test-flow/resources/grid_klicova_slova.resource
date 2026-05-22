*** Settings ***
Library    Browser
Library    Collections

*** Keywords ***
Mřížka by měla obsahovat sloupce
    [Arguments]    @{ocekavane_sloupce}
    FOR    ${sloupec}    IN    @{ocekavane_sloupce}
        Wait For Elements State    .a-GV-headerLabel:has-text("${sloupec}")    visible
    END

Mřížka by měla mít přesně tyto sloupce
    [Arguments]    @{ocekavane_sloupce}
    ${aktualni_sloupce}=    Get Elements    .a-GV-headerLabel
    ${texty}=    Create List
    FOR    ${el}    IN    @{aktualni_sloupce}
        ${t}=    Get Text    ${el}
        IF    "${t}" != ""
            Append To List    ${texty}    ${t}
        END
    END
    Lists Should Be Equal    ${texty}    ${ocekavane_sloupce}

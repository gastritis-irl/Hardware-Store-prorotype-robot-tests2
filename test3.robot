*** Settings ***
Documentation     DB to UI: Remove Product
Suite Teardown    Close Browser

*** Variables ***

*** Test Cases ***
Test product delete
    [Tags]   DB_to_UI
    DB actions
    Login in Browser
    Look for Product
    Close All Browsers

*** Keywords ***
Login in Browser
    Open Browser    ${BASE_URL}${LOGIN_URL}    ${BROWSER}
    Input Text    id=username    ${DEF_USER}
    Input Text    id=password    ${DEF_PASSWORD}
    Click Button    id=login

DB actions
    Connect To Database    pymysql  ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    Delete Record
    Disconnect From Database

Delete Record
    ${query}=    Set Variable    DELETE FROM product WHERE title = '${TITLE}' AND price = ${PRICE} AND qt = ${QT} LIMIT 1
    Execute SQL String    ${query}

Look for Product
    Page Should Not Contain    '${TITLE}'

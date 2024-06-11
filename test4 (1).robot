*** Settings ***
Documentation     DB to UI: Add User and Verify Login (WSL2)
Suite Teardown    Close Browser
Library           SeleniumLibrary
Library           DatabaseLibrary
Library           Process
Library           OperatingSystem

*** Variables ***
${DB_HOST}          localhost
${DB_PORT}          3307  
${DB_NAME}          jdbcdb 
${DB_USER}          jdbcuser
${DB_PASS}          1234

${USERNAME}         user1@user
${PASSWORD}         password 
# URLs (adjust these based on your app structure)
${BASE_URL}         http://localhost:5173/ 
${LOGIN_URL}        login
${USER_URL}      profile

*** Test Cases ***
Setup
    [Tags]    DB_to_UI
    DB Actions
    Login In Browser
    Check Products Page  

*** Keywords ***
DB Actions
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    Add User
    Disconnect From Database

Add User
    ${count} =    Query    SELECT COUNT(*) FROM users WHERE email='${USERNAME}'
    Run Keyword If    ${count}[0][0] > 0    Fail    User already exists

    ${query} =    Set Variable    INSERT INTO users (email, password, role, theme_id) VALUES ('${USERNAME}', '${PASSWORD}', 'USER', 1) 
    Execute SQL String    ${query}

Login In Browser
    ${LOGIN_URL} =    Set Variable    http://localhost:5173/${LOGIN_URL}
    Open Browser    ${LOGIN_URL}    browser=chrome
    Input Text      id=username    ${USERNAME}
    Input Text      id=password    ${PASSWORD}
    Click Button    id=login

Check Products Page
    Wait Until Page Contains   xpath=//*[@id="root"]/div[2]/header/div/div/button    5s
    ${current_url}profile =    Get Location
    Should Be Equal    ${current_url}    ${BASE_URL}${USER_URL}

Close Browser
    Close All Browsers

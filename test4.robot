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
${EDGE_DRIVER_PATH} /home/csabee/WebDriver/msedgedriver

${USERNAME}         newuser123
${PASSWORD}         testpassword 
# URLs (adjust these based on your app structure)
${BASE_URL}         http://${WINDOWS_HOST_IP}:5173/ 
${LOGIN_URL}        login
${PRODUCT_URL}      products   # Assuming 'products' is the protected page

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
    ${count} =    Query    SELECT COUNT(*) FROM users WHERE username='${USERNAME}'
    Run Keyword If    ${count}[0][0] > 0    Fail    User already exists

    ${query} =    Set Variable    INSERT INTO users (username, password) VALUES ('${USERNAME}', '${PASSWORD}') 
    Execute SQL String    ${query}

Login In Browser
    ${HOSTNAME} =    Get Hostname
    ${LOGIN_URL} =    Set Variable    http://${HOSTNAME}.local:5173/${LOGIN_URL}
    Open Browser    ${LOGIN_URL}    executable_path=${EDGE_DRIVER_PATH}
    Input Text      id=username    ${USERNAME}
    Input Text      id=password    ${PASSWORD}
    Click Button    id=login

Check Products Page
    Wait Until Page Contains    ${USERNAME}    5s
    ${current_url} =    Get Location
    Should Be Equal    ${current_url}    ${BASE_URL}${PRODUCT_URL}

Close Browser
    Close All Browsers

*** Settings ***
Documentation     DB to UI: Remove Product from Hardware Store Prototype (WSL2)
Suite Teardown    Close Browser
Library           SeleniumLibrary
Library           DatabaseLibrary
Library           Process
Library           OperatingSystem

*** Variables ***
${WINDOWS_HOST_IP}  localhost
${DB_HOST}          localhost
${DB_PORT}          3307
${DB_NAME}          jdbcdb  
${DB_USER}          jdbcuser
${DB_PASS}          1234

${BASE_URL}         http://${WINDOWS_HOST_IP}:5173/
# Assuming default login URL from the app repo:
${LOGIN_URL}        login
${DEF_USER}         admin@admin  # Default username
${DEF_PASSWORD}      password  # Default password

# Product details to delete - adjust to your specific test data
${TITLE}            Corsair MM800 RGB Polaris 

*** Test Cases ***
Test Product Delete
    [Tags]    DB_to_UI
    Open Browser   ${BASE_URL}login   browser=chrome
    DB Actions
    Login In Browser
    Look For Product
    Close browser
    
*** Keywords ***
DB Actions
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    Delete Record
    Disconnect From Database

Delete Record
    ${query} =    Set Variable    DELETE FROM hardware_parts WHERE name = '${TITLE}' LIMIT 1  
    Execute SQL String    ${query}

Login In Browser
    Input Text      id=username    ${DEF_USER}
    Input Text      id=password    ${DEF_PASSWORD}
    Click Button    id=login

Look For Product
    Click Element  xpath=//*[@id="menu"]
    Click Element  xpath=//*[@id="simple-menu"]/div[3]/ul/a[1]
    Page Should Not Contain    ${TITLE}  

Close Browser
    Close All Browsers

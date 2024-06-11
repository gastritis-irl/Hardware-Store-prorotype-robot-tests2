** Settings **
Documentation   Tests for Example Store with WSL2 & Docker MySQL
Library      SeleniumLibrary
Library      DatabaseLibrary
Library      Process

#Suite Setup    Run Keywords
#  ...      Connect To Database
#  ...      Open Browser To Register Page
#Suite Teardown  Close All Browsers

* Variables *
${WINDOWS_HOST_IP}  172.25.48.1
${URL}        http://${WINDOWS_HOST_IP}:5173/register
${DB_HOST}      localhost
${DB_PORT}      3307
${DB_NAME}      jdbcdb
${DB_USER}      jdbcuser
${DB_PASS}      1234
${TITLE}       Test Product
${PRICE}       3000
${CATEGORY}     CPU
${MANUFACTURER}   Intel
${DESCRIPTION}    This is a test product.

*** Test Cases ***
Register Should Be Reflected In Database
  [Tags]     UI-to-DB

    Connect To myDatabase
  Open Browser   ${URL}   browser=edge
  Input Text   id=username    example@user.com
  Input Text   id=password    password
  Click Button  id=register

  # Query the database to check if the registration was successful
  ${count} =    Query    SELECT COUNT(*) FROM users WHERE email='example@user.com'
  Should Be Equal   ${count[0][0]}  ${1}

  Close Browser

*** Keywords ***

Product Should Be In Database
  [Tags]     UI-to-DB
  Click Button  id=menu
  Click Button  id=add-new
  Input Text   id=name     ${TITLE}
  Input Text   id=price    ${PRICE}
  Select From List id=category-select   ${CATEGORY}
  Input Text   id=manufacturer ${MANUFACTURER}
  Input Text   id=description  ${DESCRIPTION}
  Click Button  id=submit

  Verify Product In Database

Open Browser To Register Page
  Open Browser  ${URL}  driver=chrome

Connect To myDatabase
  DatabaseLibrary.Connect To Database  pymysql  ${DB_NAME}  ${DB_USER}  ${DB_PASS}  localhost  ${DB_PORT}   

Verify Product In Database
  ${result} =  Query  SELECT name FROM product WHERE name='${TITLE}' AND price=${PRICE}
  Should Not Be Empty  ${result}  The product should have been found in the database.

Close Browser
  Close All Browsers
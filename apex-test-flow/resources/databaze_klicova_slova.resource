*** Settings ***
Library    DatabaseLibrary

*** Keywords ***
Připoj se k databázi
    Connect To Database    db_module=oracledb    db_name=FREEPDB1    db_user=test_ws    db_password=test_ws    db_host=147.228.51.30    db_port=6521

Odpoji se od databáze
    Disconnect From Database

Odstraň testovací data
    Připoj se k databázi
    Execute Sql Script    ${CURDIR}/../db/teardown/uklid_testovacich_dat.sql
    Odpoji se od databáze

Pokud připravím kurz s volnou kapacitou
    Připoj se k databázi
    Execute Sql Script    ${CURDIR}/../db/setup/kurz_pred_deadlinem.sql
    ${count}=    Query    SELECT count(*) FROM UTS_KURZY WHERE nazev = 'AUTO_TEST_VOLNY'
    Log To Console    \n[DB SETUP] Připraven kurz: AUTO_TEST_VOLNY (nalezeno ${count[0][0]}x)
    Odpoji se od databáze

Pokud připravím kurz po deadlinu
    Připoj se k databázi
    Execute Sql Script    ${CURDIR}/../db/setup/kurz_po_deadlinu.sql
    ${count}=    Query    SELECT count(*) FROM UTS_KURZY WHERE nazev = 'AUTO_TEST_PO_DEADLINU'
    Log To Console    \n[DB SETUP] Připraven kurz: AUTO_TEST_PO_DEADLINU (nalezeno ${count[0][0]}x)
    Odpoji se od databáze

Pokud připravím plně obsazený kurz
    Připoj se k databázi
    Execute Sql Script    ${CURDIR}/../db/setup/kurz_plny.sql
    ${count}=    Query    SELECT count(*) FROM UTS_KURZY WHERE nazev = 'AUTO_TEST_PLNY'
    Log To Console    \n[DB SETUP] Připraven kurz: AUTO_TEST_PLNY (nalezeno ${count[0][0]}x)
    Odpoji se od databáze

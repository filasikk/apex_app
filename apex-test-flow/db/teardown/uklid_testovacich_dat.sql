-- Nejdřív smažeme všechny přihlášky (zatím všechny, jak jsi chtěl)
DELETE FROM UTS_PRIHLASKY;

-- Potom smažeme jen testovací kurzy
DELETE FROM UTS_KURZY WHERE nazev LIKE 'AUTO_TEST_%';

COMMIT;

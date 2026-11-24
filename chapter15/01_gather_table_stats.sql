CREATE OR REPLACE PROCEDURE ch15_example1_prc
IS
BEGIN
  FOR t IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
    DBMS_STATS.GATHER_TABLE_STATS(
      ownname => USER,
      tabname => t.table_name
    );
  END LOOP;
END;
/

SHOW ERRORS PROCEDURE ch15_example1_prc

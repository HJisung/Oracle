SET SERVEROUTPUT ON
DECLARE
  v_select NUMBER := DBMS_SQL.OPEN_CURSOR;
  v_insert NUMBER := DBMS_SQL.OPEN_CURSOR;
  v_result NUMBER;
  v_id ch13_physicist.ids%TYPE;
  v_name ch13_physicist.names%TYPE;
  v_date ch13_physicist.birth_dt%TYPE;
BEGIN
  ch13_exam_crt_table_proc('CH13_PHYSICIST');
  DELETE FROM ch13_physicist_new;
  DBMS_SQL.PARSE(v_select, 'SELECT ids, names, birth_dt FROM ch13_physicist', DBMS_SQL.NATIVE);
  DBMS_SQL.DEFINE_COLUMN(v_select, 1, v_id);
  DBMS_SQL.DEFINE_COLUMN(v_select, 2, v_name, 80);
  DBMS_SQL.DEFINE_COLUMN(v_select, 3, v_date);
  v_result := DBMS_SQL.EXECUTE(v_select);
  DBMS_SQL.PARSE(v_insert, 'INSERT INTO ch13_physicist_new VALUES (:a, :b, :c)', DBMS_SQL.NATIVE);
  WHILE DBMS_SQL.FETCH_ROWS(v_select) > 0 LOOP
    DBMS_SQL.COLUMN_VALUE(v_select, 1, v_id);
    DBMS_SQL.COLUMN_VALUE(v_select, 2, v_name);
    DBMS_SQL.COLUMN_VALUE(v_select, 3, v_date);
    DBMS_SQL.BIND_VARIABLE(v_insert, ':a', v_id);
    DBMS_SQL.BIND_VARIABLE(v_insert, ':b', v_name);
    DBMS_SQL.BIND_VARIABLE(v_insert, ':c', v_date);
    v_result := DBMS_SQL.EXECUTE(v_insert);
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_select);
  DBMS_SQL.CLOSE_CURSOR(v_insert);
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  IF DBMS_SQL.IS_OPEN(v_select) THEN DBMS_SQL.CLOSE_CURSOR(v_select); END IF;
  IF DBMS_SQL.IS_OPEN(v_insert) THEN DBMS_SQL.CLOSE_CURSOR(v_insert); END IF;
  ROLLBACK;
  RAISE;
END;
/
SELECT * FROM ch13_physicist_new ORDER BY ids;

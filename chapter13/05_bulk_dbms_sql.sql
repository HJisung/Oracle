SET SERVEROUTPUT ON
DECLARE
  v_ids DBMS_SQL.NUMBER_TABLE;
  v_names DBMS_SQL.VARCHAR2_TABLE;
  v_dates DBMS_SQL.DATE_TABLE;
  v_cursor NUMBER := DBMS_SQL.OPEN_CURSOR;
  v_result NUMBER;
BEGIN
  ch13_exam_crt_table_proc('CH13_PHYSICIST');
  DELETE FROM ch13_physicist_new;
  SELECT ids, names, birth_dt BULK COLLECT INTO v_ids, v_names, v_dates FROM ch13_physicist;
  IF v_ids.COUNT > 0 THEN
    DBMS_SQL.PARSE(v_cursor, 'INSERT INTO ch13_physicist_new VALUES (:a, :b, :c)', DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_ARRAY(v_cursor, ':a', v_ids);
    DBMS_SQL.BIND_ARRAY(v_cursor, ':b', v_names);
    DBMS_SQL.BIND_ARRAY(v_cursor, ':c', v_dates);
    v_result := DBMS_SQL.EXECUTE(v_cursor);
    DBMS_OUTPUT.PUT_LINE('입력 건수: ' || v_result);
  END IF;
  DBMS_SQL.CLOSE_CURSOR(v_cursor);
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  IF DBMS_SQL.IS_OPEN(v_cursor) THEN DBMS_SQL.CLOSE_CURSOR(v_cursor); END IF;
  ROLLBACK;
  RAISE;
END;
/
SELECT * FROM ch13_physicist_new ORDER BY ids;

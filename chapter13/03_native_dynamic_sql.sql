SET SERVEROUTPUT ON
DECLARE
  v_cur SYS_REFCURSOR;
  v_row ch13_physicist%ROWTYPE;
BEGIN
  ch13_exam_crt_table_proc('CH13_PHYSICIST');
  DELETE FROM ch13_physicist_new;
  OPEN v_cur FOR 'SELECT ids, names, birth_dt FROM ch13_physicist';
  LOOP
    FETCH v_cur INTO v_row;
    EXIT WHEN v_cur%NOTFOUND;
    EXECUTE IMMEDIATE 'INSERT INTO ch13_physicist_new (ids, names, birth_dt) VALUES (:1, :2, :3)'
      USING v_row.ids, v_row.names, v_row.birth_dt;
  END LOOP;
  CLOSE v_cur;
  COMMIT;
END;
/
SELECT * FROM ch13_physicist_new ORDER BY ids;

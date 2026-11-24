CREATE OR REPLACE PROCEDURE ch13_exam_crt_table_proc(pv_src_table IN VARCHAR2) IS
  v_source VARCHAR2(30) := DBMS_ASSERT.SIMPLE_SQL_NAME(UPPER(pv_src_table));
  v_target VARCHAR2(30);
BEGIN
  IF LENGTH(v_source) > 26 THEN RAISE_APPLICATION_ERROR(-20001, '테이블 이름이 너무 깁니다.'); END IF;
  v_target := v_source || '_NEW';
  EXECUTE IMMEDIATE 'CREATE TABLE ' || v_target || ' AS SELECT * FROM ' || v_source || ' WHERE 1 = 0';
END;
/
-- 선행: 00_setup_physicists.sql
EXEC ch13_exam_crt_table_proc('CH13_PHYSICIST');

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ch13_exam_crt_table_proc(pv_src_table IN VARCHAR2) IS
  v_source VARCHAR2(30) := DBMS_ASSERT.SIMPLE_SQL_NAME(UPPER(pv_src_table));
  v_target VARCHAR2(30);
  v_count NUMBER;
BEGIN
  IF LENGTH(v_source) > 26 THEN RAISE_APPLICATION_ERROR(-20001, '테이블 이름이 너무 깁니다.'); END IF;
  v_target := v_source || '_NEW';
  SELECT COUNT(*) INTO v_count FROM user_tables WHERE table_name = v_target;
  IF v_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE(v_target || ' 테이블이 이미 존재합니다.');
    RETURN;
  END IF;
  EXECUTE IMMEDIATE 'CREATE TABLE ' || v_target || ' AS SELECT * FROM ' || v_source || ' WHERE 1 = 0';
END;
/
EXEC ch13_exam_crt_table_proc('CH13_PHYSICIST');

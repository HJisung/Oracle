SET SERVEROUTPUT ON

DECLARE
  v_table_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_table_count
    FROM user_tables
   WHERE table_name = 'EMP_BULK';

  IF v_table_count = 0 THEN
    EXECUTE IMMEDIATE
      'CREATE TABLE emp_bulk AS
       SELECT employee_id, job_id, CAST(NULL AS VARCHAR2(80)) AS job_title
         FROM employees';
    DBMS_OUTPUT.PUT_LINE('EMP_BULK 실습 테이블을 생성했습니다.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('기존 EMP_BULK 테이블을 유지합니다.');
  END IF;
END;
/

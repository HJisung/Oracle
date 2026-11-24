SET SERVEROUTPUT ON
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM user_tables WHERE table_name = 'CH13_PHYSICIST';
  IF v_count = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE ch13_physicist (ids NUMBER, names VARCHAR2(80), birth_dt DATE)';
    EXECUTE IMMEDIATE 'INSERT INTO ch13_physicist VALUES (1, ''Galileo Galilei'', DATE ''1564-02-15'')';
    EXECUTE IMMEDIATE 'INSERT INTO ch13_physicist VALUES (2, ''Isaac Newton'', DATE ''1643-01-04'')';
    EXECUTE IMMEDIATE 'INSERT INTO ch13_physicist VALUES (3, ''Max Planck'', DATE ''1858-04-23'')';
    EXECUTE IMMEDIATE 'INSERT INTO ch13_physicist VALUES (4, ''Albert Einstein'', DATE ''1879-03-14'')';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('예제 테이블과 데이터 생성 완료');
  ELSE
    DBMS_OUTPUT.PUT_LINE('기존 테이블을 유지합니다.');
  END IF;
END;
/

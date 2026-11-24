SET SERVEROUTPUT ON

DECLARE
  vn_base_num NUMBER := 3;
BEGIN
  FOR i IN REVERSE 9..1 LOOP
    DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '= ' || vn_base_num * i);
  END LOOP;
END;
/

-- 범위의 하한 9가 상한 1보다 커서 반복문이 한 번도 실행되지 않는다.
-- REVERSE 1..9로 쓰면 9부터 1까지 역순으로 반복한다.

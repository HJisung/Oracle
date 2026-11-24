SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE ch12_seq_pkg IS
  FUNCTION get_nextval RETURN NUMBER;
END ch12_seq_pkg;
/
CREATE OR REPLACE PACKAGE BODY ch12_seq_pkg IS
  v_value NUMBER := 0;
  FUNCTION get_nextval RETURN NUMBER IS
  BEGIN
    v_value := v_value + 1;
    RETURN v_value;
  END;
END ch12_seq_pkg;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE(ch12_seq_pkg.get_nextval);
  DBMS_OUTPUT.PUT_LINE(ch12_seq_pkg.get_nextval);
END;
/

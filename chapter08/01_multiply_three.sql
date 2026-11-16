SET SERVEROUTPUT ON

BEGIN
  FOR n IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE('3 * ' || n || ' = ' || 3 * n);
  END LOOP;
END;
/

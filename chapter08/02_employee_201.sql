SET SERVEROUTPUT ON

DECLARE
  v_name  employees.emp_name%TYPE;
  v_email employees.email%TYPE;
BEGIN
  SELECT emp_name, email
    INTO v_name, v_email
    FROM employees
   WHERE employee_id = 201;

  DBMS_OUTPUT.PUT_LINE(v_name || ' - ' || v_email);
END;
/

SET SERVEROUTPUT ON
DECLARE
  TYPE email_by_name IS TABLE OF employees.email%TYPE INDEX BY VARCHAR2(80);
  v_emails email_by_name;
  v_name VARCHAR2(80);
BEGIN
  FOR rec IN (SELECT emp_name, email FROM employees ORDER BY employee_id) LOOP
    v_emails(rec.emp_name) := rec.email;
  END LOOP;
  v_name := v_emails.FIRST;
  WHILE v_name IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE(v_name || ' - ' || v_emails(v_name));
    v_name := v_emails.NEXT(v_name);
  END LOOP;
END;
/

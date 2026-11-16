SET SERVEROUTPUT ON

DECLARE
  v_next_id employees.employee_id%TYPE;
BEGIN
  SELECT NVL(MAX(employee_id), 0) + 1
    INTO v_next_id
    FROM employees;

  INSERT INTO employees (employee_id, emp_name, email, hire_date, department_id)
  VALUES (v_next_id, 'Harrison Ford', 'HARRIS', SYSDATE, 50);

  DBMS_OUTPUT.PUT_LINE('Inserted employee ID: ' || v_next_id);
END;
/

COMMIT;

SELECT employee_id, emp_name, email, hire_date, department_id
  FROM employees
 WHERE email = 'HARRIS'
 ORDER BY employee_id;

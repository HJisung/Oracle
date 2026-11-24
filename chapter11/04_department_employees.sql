SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ch11_emp_proc(p_department_id IN departments.department_id%TYPE) IS
  CURSOR c_emp IS
    SELECT e.employee_id, e.emp_name, d.department_name
      FROM employees e JOIN departments d ON e.department_id = d.department_id
     WHERE e.department_id = p_department_id;
  TYPE employee_rows IS TABLE OF c_emp%ROWTYPE;
  v_rows employee_rows;
BEGIN
  OPEN c_emp;
  FETCH c_emp BULK COLLECT INTO v_rows;
  CLOSE c_emp;
  FOR i IN 1..v_rows.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_rows(i).employee_id || ' ' || v_rows(i).emp_name || ' ' || v_rows(i).department_name);
  END LOOP;
END;
/
EXEC ch11_emp_proc(10);

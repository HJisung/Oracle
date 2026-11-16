SELECT employee_id, emp_name, hire_date,
       TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS service_years
  FROM employees
 WHERE MONTHS_BETWEEN(SYSDATE, hire_date) >= 120
 ORDER BY service_years DESC, employee_id;

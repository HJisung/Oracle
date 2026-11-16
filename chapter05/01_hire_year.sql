SELECT TO_CHAR(hire_date, 'YYYY') AS hire_year,
       COUNT(*) AS employee_count
  FROM employees
 GROUP BY TO_CHAR(hire_date, 'YYYY')
 ORDER BY hire_year;

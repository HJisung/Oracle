SELECT e.employee_id, e.emp_name, j.job_title,
       h.start_date, h.end_date, d.department_name
  FROM employees e
  JOIN job_history h ON e.employee_id = h.employee_id
  JOIN departments d ON h.department_id = d.department_id
  JOIN jobs j ON h.job_id = j.job_id
 WHERE e.employee_id = 101;

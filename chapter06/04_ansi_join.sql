SELECT d.department_id, d.department_name
  FROM departments d
  INNER JOIN employees e ON d.department_id = e.department_id
 WHERE e.salary > 3000
 ORDER BY d.department_name;

SELECT d.department_id, d.department_name
  FROM departments d
 WHERE d.department_id IN (SELECT department_id FROM job_history)
 ORDER BY d.department_id;

SELECT department_id,
       SUBSTR(SYS_CONNECT_BY_PATH(emp_name, ','), 2) AS empnames
  FROM (SELECT department_id, emp_name,
               ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY emp_name) AS rn,
               COUNT(*) OVER (PARTITION BY department_id) AS cnt
          FROM employees
         WHERE department_id IS NOT NULL)
 WHERE rn = cnt
 START WITH rn = 1
CONNECT BY PRIOR department_id = department_id AND PRIOR rn + 1 = rn
 ORDER BY department_id;

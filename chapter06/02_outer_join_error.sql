-- 두 테이블의 서로 다른 쪽에 (+)를 붙여 ORA-01416이 발생한다.
-- 기존 (+) 외부 조인에서는 두 테이블이 서로를 외부 조인할 수 없다.
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id(+)
   AND a.department_id(+) = b.department_id;

-- employees를 기준으로 유지하려면 두 조건 모두 job_history 쪽에 (+)를 붙인다.
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id(+)
   AND a.department_id = b.department_id(+);

-- IN (10, 20)은 여러 동등 비교를 OR로 연결한 것과 같다.
-- 오래된 오라클 버전에서는 (+)가 붙은 조건과 OR/다중 IN의 결합이 제한된다.
-- IN (10)은 동등 비교 (= 10)로 처리할 수 있어 허용된다.
-- 현재 실습 환경인 Oracle 11g에서는 IN (10, 20)도 실행된다.
SELECT COUNT(*) AS one_value_count
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id(+)
   AND b.department_id(+) IN (10);

SELECT COUNT(*) AS two_value_count
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id(+)
   AND b.department_id(+) IN (10, 20);

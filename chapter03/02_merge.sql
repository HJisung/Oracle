-- 사전 준비: 책에서 앞서 만든 보너스 테이블
CREATE TABLE ex3_3 (
    employee_id NUMBER,
    bonus_amt   NUMBER DEFAULT 0
);

DELETE FROM ex3_3;

INSERT INTO ex3_3 (employee_id)
SELECT e.employee_id
  FROM employees e, sales s
 WHERE e.employee_id = s.employee_id
   AND s.sales_month BETWEEN '200010' AND '200012'
 GROUP BY e.employee_id;

COMMIT;

MERGE INTO ex3_3 target
USING (SELECT employee_id, salary FROM employees WHERE manager_id = 145) source
   ON (target.employee_id = source.employee_id)
 WHEN MATCHED THEN
      UPDATE SET target.bonus_amt = target.bonus_amt + source.salary * 0.01
 WHEN NOT MATCHED THEN
      INSERT (employee_id, bonus_amt)
      VALUES (source.employee_id, source.salary * 0.005);

SELECT * FROM ex3_3 ORDER BY employee_id;

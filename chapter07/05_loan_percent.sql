-- 과제 표의 203110은 실제 데이터의 201310으로 해석한다.
WITH loan_totals AS (
  SELECT region, gubun,
         SUM(CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END) AS a1,
         SUM(CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END) AS a2,
         SUM(CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END) AS a3,
         SUM(CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END) AS a4,
         SUM(CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END) AS a5,
         SUM(CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END) AS a6,
         SUM(CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END) AS a7
    FROM kor_loan_status
   GROUP BY region, gubun
)
SELECT region, gubun,
       a1 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a1) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201111",
       a2 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a2) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201112",
       a3 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a3) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201210",
       a4 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a4) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201211",
       a5 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a5) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201212",
       a6 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a6) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201310",
       a7 || ' (' || NVL(ROUND(RATIO_TO_REPORT(a7) OVER (PARTITION BY region) * 100), 0) || '%)' AS "201311"
  FROM loan_totals
 ORDER BY region, gubun;

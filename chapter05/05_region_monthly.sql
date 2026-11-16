-- 과제 표의 203110은 실제 데이터의 201310으로 해석한다.
SELECT region,
       SUM(CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END) AS "201111",
       SUM(CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END) AS "201112",
       SUM(CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END) AS "201210",
       SUM(CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END) AS "201211",
       SUM(CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END) AS "201212",
       SUM(CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END) AS "201310",
       SUM(CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END) AS "201311"
  FROM kor_loan_status
 GROUP BY region
 ORDER BY region;

SELECT period, SUM(loan_jan_amt) AS mortgage_loan, 0 AS other_loan
  FROM kor_loan_status
 WHERE period = '201311' AND gubun = '주택담보대출'
 GROUP BY period, gubun
UNION ALL
SELECT period, 0 AS mortgage_loan, SUM(loan_jan_amt) AS other_loan
  FROM kor_loan_status
 WHERE period = '201311' AND gubun = '기타대출'
 GROUP BY period, gubun;

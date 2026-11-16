SELECT TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - c.cust_year_of_birth) / 10) * 10 || '대' AS age_group,
       SUM(s.amount_sold) AS total_sales
  FROM sales s
  JOIN customers c ON s.cust_id = c.cust_id
 WHERE s.sales_month = '200112'
 GROUP BY TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - c.cust_year_of_birth) / 10)
 ORDER BY TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - c.cust_year_of_birth) / 10);

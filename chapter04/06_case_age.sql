SELECT cust_name, cust_year_of_birth,
       CASE
         WHEN cust_year_of_birth IS NULL THEN '기타'
         WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth < 0 THEN '기타'
         ELSE TO_CHAR(TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) * 10) || '대'
       END AS generation
  FROM customers;

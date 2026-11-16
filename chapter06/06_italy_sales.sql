WITH yearly_sales AS (
  SELECT SUBSTR(s.sales_month, 1, 4) AS sales_year,
         s.employee_id, SUM(s.amount_sold) AS amount_sold
    FROM sales s
    JOIN customers c ON s.cust_id = c.cust_id
    JOIN countries co ON c.country_id = co.country_id
   WHERE co.country_name = 'Italy'
   GROUP BY SUBSTR(s.sales_month, 1, 4), s.employee_id
), sales_extremes AS (
  SELECT sales_year, employee_id, amount_sold,
         MAX(amount_sold) OVER (PARTITION BY sales_year) AS max_sold,
         MIN(amount_sold) OVER (PARTITION BY sales_year) AS min_sold
    FROM yearly_sales
)
SELECT s.sales_year, s.employee_id, e.emp_name, s.amount_sold
  FROM sales_extremes s
  JOIN employees e ON s.employee_id = e.employee_id
 WHERE s.amount_sold = s.max_sold OR s.amount_sold = s.min_sold
 ORDER BY s.sales_year, s.amount_sold DESC, s.employee_id;

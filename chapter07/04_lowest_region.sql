WITH monthly_sales AS (
  SELECT s.sales_month, co.country_region, SUM(s.amount_sold) AS total_sales
    FROM sales s
    JOIN customers c ON s.cust_id = c.cust_id
    JOIN countries co ON c.country_id = co.country_id
   GROUP BY s.sales_month, co.country_region
), ranked_sales AS (
  SELECT sales_month, country_region, total_sales,
         RANK() OVER (PARTITION BY sales_month ORDER BY total_sales) AS sales_rank
    FROM monthly_sales
)
SELECT sales_month, country_region, total_sales
  FROM ranked_sales
 WHERE sales_rank = 1
 ORDER BY sales_month, country_region;

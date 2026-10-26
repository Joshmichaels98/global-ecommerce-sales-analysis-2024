-- Sales Analysis
-- Purpose: Analyze sales performance over time and across countries using monthly revenue trends, cumulative revenue and order volumes by country.

--Running revenue total
WITH MOnthlySales AS ( 
	SELECT 
		DATE_TRUNC('month', order_date) AS month, 
		SUM(amount) AS revenue
		
	FROM orders
	GROUP BY 1
	ORDER BY 1
)

SELECT *, 
SUM(revenue) OVER(ORDER BY month) AS running_total
FROM monthlySales;


--Monthly revenue trend
SELECT 
	DATE_TRUNC('month', order_date) AS month,
	SUM(amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month;


-- Orders per country
SELECT 
	c.country, 
	COUNT(o.order_id) AS number_of_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY country;
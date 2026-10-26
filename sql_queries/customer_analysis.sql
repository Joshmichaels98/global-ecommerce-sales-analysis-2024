-- Customer Analysis
-- Purpose: Examine customer spending patterns and compare customer value through total spending, average order value, spending relative to the customer average and spending leaders by country.

-- Top 5 customers by total spending
SELECT c.customer_id, 
	   c.customer_name, 
	   SUM(o.amount) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;


-- Average order value per customer
SELECT c.customer_id, 
	   c.customer_name, 
	   AVG(o.amount) AS average_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


-- Customers spending above the average
WITH customers_total AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(o.amount) AS total_spending
    FROM   customers c
    JOIN   orders o
    ON     c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)

SELECT *
FROM customers_total
WHERE total_spending > (
    SELECT AVG(total_spending)
    FROM customers_total
);


-- Top customers per country
WITH top_customers AS(
	SELECT c.customer_id, 
		   c.customer_name, c.country,
		   SUM(o.amount) AS total_spending,
		   ROW_NUMBER () OVER (PARTITION BY c.country ORDER BY SUM(o.amount) DESC) AS row_number
	FROM customers c
	JOIN orders o
	ON 	 c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.customer_name, c.country 
)

SELECT *
FROM top_customers
WHERE row_number = 1
ORDER BY total_spending DESC;


--Highest order per customer 
WITH highest_order AS(
	SELECT c.customer_id,
		   c.customer_name,
		   o.amount,
		   ROW_NUMBER () OVER (PARTITION BY c.customer_id ORDER BY o.amount DESC) AS row_number
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
)

SELECT *
FROM highest_order
WHERE row_number = 1;
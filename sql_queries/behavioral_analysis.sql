-- Behavioral Analysis
-- Purpose: Investigate purchasing behavior at the order level by examining the time between successive orders and comparing order amounts within each customer's purchase history.

-- Days between customers orders
WITH customers_order_date AS(
	SELECT 
		c.customer_id, 
		o.order_id,
		o.order_date,
	    LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS previous_order_date
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
)
SELECT *, 
	   order_date - previous_order_date AS days_between
FROM customers_order_date;


-- Total customer spending
SELECT 
	c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


--customer order ranking
SELECT 
	c.customer_id,
	o.order_id, o.amount,
	RANK() OVER (PARTITION BY c.customer_id ORDER BY o.amount DESC) AS rank
FROM customers c
JOIN orders o
ON   c.customer_id = o.customer_id;








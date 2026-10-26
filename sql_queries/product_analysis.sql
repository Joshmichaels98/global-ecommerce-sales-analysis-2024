-- Product Analysis
-- Purpose: Evaluate product and category performance by comparing sales volume, product revenue, leading products within categories and revenue contributions across categories.

-- Top 5 product by quantity sold
SELECT p.product_id,
	   p.product_name, 
	   SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- Top 5 product by revenue
SELECT p.product_id, 
	   p.product_name,
	   SUM(oi.quantity * p.price) AS total_revenue
FROM   products p
JOIN   order_items oi
ON	   p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;


-- Top 5 product by quantity sold (including ties)
WITH total_quantity AS (
	SELECT p.product_id,
		   p.product_name, 
		   SUM(oi.quantity) AS total_quantity_sold,
		   DENSE_RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS sales_rank
	FROM products p
	JOIN order_items oi
	ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name
	ORDER BY total_quantity_sold DESC
)
SELECT *
FROM total_quantity
WHERE sales_rank <=5;


-- Most popular product per category
WITH top_product AS(
	SELECT p.product_id, p.product_name, p.category, 
		SUM(oi.quantity) AS total_quantity_sold,
		ROW_NUMBER () OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS row_number
	FROM products p
	JOIN order_items oi
	ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name, p.category
)

SELECT *
FROM top_product
WHERE row_number = 1;


-- Total revenue per category
SELECT p.category,
	   SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
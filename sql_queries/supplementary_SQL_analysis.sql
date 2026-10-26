-- Supplementary SQL Analysis
-- Purpose: Compare product revenue and sales volume by calculating each product's share of total revenue and total units sold, identifying differences between revenue contribution and sales volume.


--Top 20 Products by Quantity Sold — Revenue and Unit Share
WITH product_summary AS (
	SELECT p.product_id,
		   p.product_name, 
	   	   SUM(oi.quantity) AS quantity_sold,
	       SUM(oi.quantity * p.price) AS revenue
	FROM products p
	JOIN order_items oi
	ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name
	
),

calculated_revenue AS (
	SELECT *,
		SUM(revenue) OVER() AS total_business_revenue,
		SUM(quantity_sold) OVER() AS total_quantity_sold	
	FROM product_summary
)
 SELECT *,
 		ROUND((revenue / total_business_revenue) * 100, 2) || '%' AS "Revenue_share",
 		ROUND((quantity_sold::NUMERIC / total_quantity_sold) * 100, 2) || '%' AS "quantity_share"
		FROM calculated_revenue
		ORDER BY quantity_sold DESC, revenue DESC, product_id ASC
		LIMIT 20;


-- Top 10 Products by Revenue — Revenue and Unit Share
WITH product_overall AS (
	SELECT p.product_id, 
	   	   p.product_name,
	       SUM(oi.quantity) AS quantity_sold,
	       SUM(oi.quantity * p.price) AS revenue
	FROM   products p
	JOIN   order_items oi
	ON	   p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name
	
),
revenue_calculation AS (
	SELECT *,
		SUM(revenue) OVER() AS total_business_revenue,
		SUM(quantity_sold) OVER() AS total_quantity_sold
	FROM product_overall
	)

SELECT *,
	ROUND((revenue / total_business_revenue) * 100, 2) || '%' AS "Revenue_share",
	ROUND((quantity_sold::NUMERIC / total_quantity_sold) * 100, 2) || '%' AS "quantity_share"
	FROM revenue_calculation
	ORDER BY revenue DESC,product_id ASC
	LIMIT 10;
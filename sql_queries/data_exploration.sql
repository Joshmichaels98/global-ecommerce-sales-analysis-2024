-- Data Exploration
-- Purpose: Establish a high level overview of the dataset by summarizing customers, orders, revenue, and quantities sold.

-- Total number of customers
SELECT 
	COUNT(customer_name) AS total_customers
FROM customers;

--Total number of active customers
SELECT 
	COUNT (DISTINCT customer_id) AS Active_customers
FROM orders;

-- Total number of orders
SELECT 
	COUNT(order_id) AS total_orders
FROM orders;

-- Total revenue
SELECT 
	SUM(amount) AS total_revenue
FROM orders;

-- Total quantity
SELECT 
	SUM(quantity) AS total_quantity
FROM order_items;
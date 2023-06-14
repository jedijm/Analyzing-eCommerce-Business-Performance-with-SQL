-- 1. Calculate Monthly Average Users

SELECT year, FLOOR(AVG(total_customer)) as average_MAU
FROM ( SELECT date_part('year', order_purchase_timestamp) AS year,
			date_part('month', order_purchase_timestamp) AS month,
			COUNT(DISTINCT cd.customer_unique_id) AS total_customer
	FROM orders_dataset AS od
	JOIN customers_dataset as cd
	  ON od.customer_id = cd.customer_id
	GROUP BY 1,2
	ORDER BY 1,2
	) AS subq
GROUP BY 1
;

-- 2. Calculate Annual Total New Customer
SELECT year, COUNT(DISTINCT customer_unique_id) as total_new_customer
FROM ( SELECT MIN(date_part('year', od.order_purchase_timestamp)) AS year, 
	   cd.customer_unique_id
FROM customers_dataset AS cd
JOIN orders_dataset AS od
		ON cd.customer_id = od.customer_id
GROUP BY 2
ORDER BY 1 
) as subq
GROUP BY 1
;

-- 3. Calculate Annual Repeat Order Customers
SELECT year, COUNT(distinct(customer_unique_id)) as total_repeat_customer
FROM ( SELECT date_part('year', od.order_purchase_timestamp) AS year,
		   cd.customer_unique_id,
		   COUNT (od.order_id) AS total_order
	FROM customers_dataset as cd
	JOIN orders_dataset as od
		ON cd.customer_id = od.customer_id
	GROUP BY 1,2
	HAVING COUNT(3) > 1
) AS subq
GROUP BY 1
;

-- Calculate Annual Order Average of Customer
SELECT year, ROUND(AVG(total_order), 5) as average_order
FROM(SELECT date_part('year', od.order_purchase_timestamp) AS year,
		   cd.customer_unique_id,
		   COUNT(od.order_id) AS total_order
	FROM customers_dataset as cd
	JOIN orders_dataset as od
	ON cd.customer_id = od.customer_id
	GROUP BY 1,2
) AS subq
GROUP BY 1
;

-- Summarize all metrics
WITH cte_mau AS (
	SELECT year, FLOOR(AVG(total_customer)) as average_MAU
	FROM ( SELECT date_part('year', order_purchase_timestamp) AS year,
			date_part('month', order_purchase_timestamp) AS month,
			COUNT(DISTINCT cd.customer_unique_id) AS total_customer
	FROM orders_dataset AS od
	JOIN customers_dataset as cd
	  ON od.customer_id = cd.customer_id
	GROUP BY 1,2
	ORDER BY 1,2
	) AS subq
	GROUP BY 1
),

cte_new_cust AS (
	SELECT year, COUNT(DISTINCT customer_unique_id) as total_new_customer
	FROM ( SELECT MIN(date_part('year', od.order_purchase_timestamp)) AS year, 
		   cd.customer_unique_id
	FROM customers_dataset AS cd
	JOIN orders_dataset AS od
			ON cd.customer_id = od.customer_id
	GROUP BY 2
	ORDER BY 1 
	) as subq
	GROUP BY 1 
),

cte_rep_ord AS(
	SELECT year, COUNT(distinct(customer_unique_id)) as total_repeat_customer
	FROM ( SELECT date_part('year', od.order_purchase_timestamp) AS year,
		   cd.customer_unique_id,
		   COUNT (od.order_id) AS total_order
	FROM customers_dataset as cd
	JOIN orders_dataset as od
		ON cd.customer_id = od.customer_id
	GROUP BY 1,2
	HAVING COUNT(3) > 1
	) AS subq
	GROUP BY 1
),

cte_avg_ord AS(
	SELECT year, ROUND(AVG(total_order), 5) as average_order
	FROM(SELECT date_part('year', od.order_purchase_timestamp) AS year,
		   cd.customer_unique_id,
		   COUNT(od.order_id) AS total_order
	FROM customers_dataset as cd
	JOIN orders_dataset as od
	ON cd.customer_id = od.customer_id
	GROUP BY 1,2
	) AS subq
	GROUP BY 1
)

SELECT rep_ord.year,
	   average_mau AS MAU,
	   total_new_customer,
	   total_repeat_customer,
	   average_order
FROM cte_mau AS mau
	 JOIN cte_new_cust AS new_cust
	 	  ON mau.year = new_cust.year
	 JOIN cte_rep_ord AS rep_ord
	 	  ON new_cust.year = rep_ord.year
	 JOIN cte_avg_ord AS avg_ord
	 	  ON rep_ord.year = avg_ord.year
GROUP BY 1,2,3,4,5
;	
		  
	   
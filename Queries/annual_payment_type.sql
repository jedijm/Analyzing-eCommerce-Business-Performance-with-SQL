SELECT payment_type, COUNT(payment_type) AS total_order
FROM order_payments_dataset
GROUP BY 1
ORDER BY 2 DESC

;
SELECT payment_type as payment_method,
	   SUM(CASE WHEN year = 2016 THEN total_order ELSE 0 END) AS "2016",
	   SUM(CASE WHEN year = 2017 THEN total_order ELSE 0 END) AS "2017",
	   SUM(CASE WHEN year = 2018 THEN total_order ELSE 0 END) AS "2018",
	   SUM(total_order) AS total_order
FROM (SELECT date_part('year', od.order_purchase_timestamp) AS year,
		  	 payment_type,
	  		 COUNT(payment_type) AS total_order
	FROM order_payments_dataset AS opd
	JOIN orders_dataset AS od
		 ON opd.order_id = od.order_id
	GROUP BY order_purchase_timestamp, payment_type
	 ) AS sub
GROUP BY 1
ORDER BY 5 DESC
--1)

WITH t1 AS(
	SELECT
		customer,
		amount,
		order_date,
    EXTRACT(DAY FROM (order_date - (ROW_NUMBER() OVER (PARTITION BY customer ORDER BY order_date ) * INTERVAL '1 day'))) AS difference
	FROM transactions
)
,max_con_days AS(
	SELECT 
		customer,
		order_date, 
		count(difference) OVER (PARTITION BY difference, customer) consecutive_days
	FROM t1
	WHERE amount > 0
)
SELECT 
	customer,
	max(consecutive_days) max_con_days
FROM max_con_days
GROUP BY customer
ORDER BY max_con_days DESC 



--2)


WITH running_total AS (
	SELECT 
		customer,
		sum(amount) over(partition by customer order by order_date) running_total_spent,
		order_date
	FROM transactions t
)
,target_customers AS ( --customers who spent more than 250
	SELECT
		DISTINCT customer
	FROM running_total
	WHERE running_total_spent > 250
)
,days_before_250 AS (
	SELECT
		customer,
		running_total_spent,
		row_number() OVER (PARTITION BY customer ORDER BY order_date) AS order_count_before_250
	FROM running_total
	WHERE 
		running_total_spent < 250
	AND customer IN (SELECT customer FROM target_customers)
)
,avg_days_before_250 AS (
	SELECT 
		customer,
		max(order_count_before_250) AS number_of_orders_before_250
	FROM days_before_250
	GROUP BY customer
)
SELECT 
	round(avg(number_of_orders_before_250)::NUMERIC) 
FROM avg_days_before_250














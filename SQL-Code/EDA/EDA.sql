-- Data Discovery
SELECT
	*
FROM
	TABLERETAIL
LIMIT
	5;
	
-----------------------------------------------------------------
SELECT
	COUNT(DISTINCT INVOICE) INVOICE_COUNT,
	COUNT(DISTINCT STOCKCODE) STOCKCODE_COUNT,
	COUNT(DISTINCT CUSTOMER_ID) CUSTOMER_COUNT,
	MAX(INVOICEDATE::DATE) AS "first order",
	MIN(INVOICEDATE::DATE) AS "last order",
	MAX(INVOICEDATE::DATE) - MIN(INVOICEDATE::DATE) "dataset time period"
FROM
	TABLERETAIL;
	
-----------------------------------------------------------------
--Questions:
/*
1- what are the top selling items? 
2- best selling month
3-best selling day
4- top 10 customers
5- sales over the day hours
*/
-----------------------------------------------------------------
-- 1- what are the top selling items?
SELECT
	STOCKCODE,
	SUM(QUANTITY) "UNITS SOLD"
FROM
	TABLERETAIL T
GROUP BY
	STOCKCODE
ORDER BY
	"UNITS SOLD" DESC
LIMIT
	5;

-----------------------------------------------------------------
-- 2- best selling month
	-- count of orders
	SELECT
		TO_CHAR(INVOICEDATE::DATE, 'Mon') "month",
		COUNT(INVOICE) "Order Count"
	FROM
		TABLERETAIL T
	GROUP BY
		"month"
	ORDER BY
		"Order Count" DESC;

	-- sales
	SELECT
		TO_CHAR(INVOICEDATE::DATE, 'Mon') "month",
		ROUND(SUM(QUANTITY * PRICE)::NUMERIC, 2) AS SALES
	FROM
		TABLERETAIL T
	GROUP BY
		"month"
	ORDER BY
		SALES DESC;

-----------------------------------------------------------------
-- 3- best selling day
	-- count of orders
	SELECT
		INVOICEDATE::DATE "date",
		COUNT(INVOICE) "Order Count"
	FROM
		TABLERETAIL T
	GROUP BY
		"date"
	ORDER BY
		"Order Count" DESC
	LIMIT
		5;

	-- sales
	SELECT
		INVOICEDATE::DATE "day",
		ROUND(SUM(QUANTITY * PRICE)::NUMERIC, 2) AS SALES
	FROM
		TABLERETAIL T
	GROUP BY
		"day"
	ORDER BY
		SALES DESC
	LIMIT
		5;
		
-----------------------------------------------------------------
-- 4- sales over the day hours
	-- count of orders
	SELECT
		TO_CHAR(INVOICEDATE::TIMESTAMP, 'HH24') AS "Hour",
		COUNT(INVOICE) AS "count of orders"
	FROM
		TABLERETAIL
	GROUP BY
		TO_CHAR(INVOICEDATE::TIMESTAMP, 'HH24')
	ORDER BY
		"Hour";

	-- sales	
	SELECT
		TO_CHAR(INVOICEDATE::TIMESTAMP, 'HH24') AS "Hour",
		ROUND(SUM(QUANTITY * PRICE)::NUMERIC, 2) AS SALES
	FROM
		TABLERETAIL
	GROUP BY
		TO_CHAR(INVOICEDATE::TIMESTAMP, 'HH24')
	ORDER BY
		"Hour";
		
-----------------------------------------------------------------
-- 5- top 5 customers
	-- count of orders
	SELECT
		CUSTOMER_ID,
		COUNT(*) "count of orders"
	FROM
		TABLERETAIL T
	GROUP BY
		CUSTOMER_ID
	ORDER BY
		"count of orders" DESC
	LIMIT
		5;

	-- sales
	SELECT
		CUSTOMER_ID,
		ROUND(SUM(QUANTITY * PRICE)::NUMERIC, 2) SALES
	FROM
		TABLERETAIL T
	GROUP BY
		CUSTOMER_ID
	ORDER BY
		SALES DESC
	LIMIT
		5;		
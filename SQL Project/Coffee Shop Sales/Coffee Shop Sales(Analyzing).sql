--1. Total Sales--
SELECT ROUND(SUM(unit_price * transaction_qty), 0)AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5

--2. Total Sales KPI-MoM Difference and MoM Growth--
SELECT
	MONTH(transaction_date) AS month,
	ROUND(SUM(unit_price * transaction_qty),0) AS total_sales,
	(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty),1)
	OVER(ORDER BY MONTH(transaction_date)))/LAG(SUM(unit_price * transaction_qty),1)
	OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_precentage
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) IN (4,5)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	MONTH(transaction_date)

--3. Total Orders--
SELECT COUNT(transaction_id) AS Total_Orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5

--4. Total Orders KPI-MoM Deffirence and MoM Growth--
SELECT
	MONTH(transaction_date) AS month,
	COUNT(transaction_id) AS total_orders,
	(CAST(COUNT(transaction_id)AS FLOAT)-LAG(COUNT(transaction_id),1)
	OVER(ORDER BY MONTH(transaction_date)))/LAG(COUNT(transaction_id),1)
	OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_precentage
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) IN (4,5)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	MONTH(transaction_date)

--5. Total Quantity Sold--
SELECT SUM(transaction_qty) AS Total_Quantity_Sold
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5

--6.Total Quantity Sold KPI-MoM Difference and MoM Growth--
SELECT
    MONTH(transaction_date) AS month,
    SUM(transaction_qty) AS total_quantity_sold,
    CAST(
        (CAST(SUM(transaction_qty) AS FLOAT) - LAG(SUM(transaction_qty), 1) 
        OVER (ORDER BY MONTH(transaction_date)))
        / LAG(SUM(transaction_qty), 1) 
        OVER (ORDER BY MONTH(transaction_date)) * 100 
    AS DECIMAL(10, 4)) AS mom_increase_precentage
FROM
    coffee_shop_sales
WHERE
    MONTH(transaction_date) IN (4, 5)
GROUP BY
    MONTH(transaction_date)
ORDER BY
    MONTH(transaction_date);

--5. Calendar Table-Daily Sales, Quantity, and Total Orders--
SELECT
	SUM(unit_price * transaction_qty) AS total_sales,
	SUM(transaction_qty) AS total_quantity_sold,
	COUNT(transaction_id) AS total_orders
FROM
	coffee_shop_sales
WHERE
	transaction_date = '2023-05-18'

--6. Sales Trend Over Period--
SELECT AVG(total_sales) AS average_sales
FROM(
	SELECT
		SUM(unit_price * transaction_qty) AS total_sales
	FROM
		coffee_shop_sales
			WHERE
		MONTH(transaction_date) = 5
	GROUP BY
		transaction_date
) AS internal_query

--7. Daily Sales For Month Selected--
SELECT
	DAY(transaction_date) AS day_of_month,
	ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM
 coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
GROUP BY
	DAY(transaction_date)
ORDER BY
	DAY(transaction_date)

--8. Comparing Daily Sales With Average Sales-If Greater Than "ABOVE AVERAGE" and Lesser Than "BELOW AVERAGE"--
SELECT
	day_of_month,
	CASE
		WHEN total_sales>avg_sales THEN 'Above Avaerage'
		WHEN total_sales<avg_sales THEN 'Below Average'
		ELSE 'Average'
	END AS sales_status,
	total_sales
FROM(
	SELECT
		DAY(transaction_date) AS day_of_month,
		SUM(unit_price * transaction_qty) AS total_sales,
		AVG(SUM(unit_price * transaction_qty))OVER () AS avg_sales
	FROM
		coffee_shop_sales
	WHERE
		MONTH(transaction_date) = 5
	GROUP BY
		DAY(transaction_date)
) AS sales_data
ORDER BY
	day_of_month

--9. Sales By Weekday/Weekend--
SELECT
	CASE
		WHEN DATEPART(weekday, transaction_date)IN(1,7) THEN 'Weekends'
		ELSE 'Weekdays'
	END AS day_type,
	ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
GROUP BY
	CASE
		WHEN DATEPART(weekday, transaction_date)IN(1,7) THEN 'Weekends'
		ELSE 'Weekdays'
	END

--10. Sales By Store Location--
SELECT
	store_location,
	SUM(unit_price * transaction_qty) AS Total_Sales
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
GROUP BY
	store_location
ORDER BY
	SUM(unit_price * transaction_qty) DESC

--11. Sales By Product Category
SELECT
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) AS Total_Sales
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
GROUP BY
	product_category
ORDER BY
	SUM(unit_price * transaction_qty) DESC

--12. Sales By Product(TOP 10)--
SELECT TOP 10
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC

--13. Sales By Day|Hour--
SELECT
	ROUND(SUM(unit_price * transaction_qty),0) AS Total_Sales,
	SUM(transaction_qty) AS Total_Quantity,
	COUNT(*) AS Total_Orders
FROM
	coffee_shop_sales
WHERE
	DATEPART(weekday, transaction_date) = 3
	AND DATEPART(HOUR, transaction_time) = 8
	AND MONTH(transaction_date) = 5
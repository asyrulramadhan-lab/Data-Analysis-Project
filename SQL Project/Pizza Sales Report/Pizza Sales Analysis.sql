SELECT * FROM pizza_sales

--1. Total Revenue
SELECT SUM(total_price) AS Total_Revenue from pizza_sales

--2. Average Order Value
SELECT
	(SUM(total_price) / COUNT(DISTINCT order_id))
	AS Avg_order_Value
FROM pizza_sales

--3. Total Pizza Sold
SELECT
	SUM(quantity) AS Total_pizza_sold
FROM pizza_sales

--4. Total Orders
SELECT
	COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales

--5. Average Pizzas Per Order
SELECT
	CAST(CAST(SUM(quantity) AS DECIMAL (10,2)) /
	CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
	AS Avg_Pizza_per_order
FROM pizza_sales

--DAILY TREND FOR TOTAL ORDERS--
SELECT
	DATENAME(DW, order_date) AS order_day,
	COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)

--MONTHLY TREND FOR ORDERS--
SELECT
	DATENAME(MONTH, order_date) AS Month_Name,
	COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)

--% OF SALES BY PIZZA CATEGORY--
SELECT pizza_category,
	CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
	CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales)
	AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

--% OF SALES BY PIZZA SIZE--
SELECT pizza_size,
	CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
	CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales)
	AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size

--TOTAL PIZZA SOLD BY PIZZA CATEGORY--
SELECT pizza_category,
	SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

--TOP 5 PIZZAS BY REVENUE--
SELECT TOP 5 pizza_name,
	SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC

--BOTTOM 5 PIZZAS BY REVENUE--
SELECT TOP 5 pizza_name,
	SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC

--TOP 5 PIZZA BY QUANTITY--
SELECT TOP 5 pizza_name,
	SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC

--BOTTOM 5 PIZZAS BY QUANTITY--
SELECT TOP 5 pizza_name,
	SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC

--TOP 5 PIZZAS BY TOTAL ORDERS--
SELECT TOP 5 pizza_name,
	COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC

--BOTTOM 5 PIZZAS BY TOTAL ORDERS--
SELECT TOP 5 pizza_name,
	COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
SELECT * FROM coffee_shop_sales

UPDATE coffee_shop_sales
SET transaction_date = CONVERT(DATE, transaction_date, 103)

ALTER TABLE coffee_shop_sales
ALTER COLUMN transaction_date DATE

UPDATE coffee_shop_sales
SET unit_price = CONVERT(FLOAT, unit_price)

ALTER TABLE coffee_shop_sales
ALTER COLUMN unit_price FLOAT

UPDATE coffee_shop_sales
SET transaction_time = CONVERT(TIME(0), transaction_time)

ALTER TABLE coffee_shop_sales
ALTER COLUMN transaction_time TIME(0)

SELECT ROUND(SUM(unit_price * transaction_qty), 0)AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
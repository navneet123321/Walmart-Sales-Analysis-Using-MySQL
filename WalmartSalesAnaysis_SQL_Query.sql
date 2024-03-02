CREATE DATABASE IF NOT EXISTS WalmartSalesData;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * FROM sales;

-- Add the time_of_day column based on condition

SELECT 
	time,
	(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
);

SELECT * FROM sales;

-- add day_name column

SELECT date FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

SELECT date,day_name FROM sales;

-- Add month_name coloumn 

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales 
SET month_name = MONTHNAME(date);

SELECT date,month_name FROM sales;

-- -------------- Business Question ------------------

-- 1. How many unique cities does the data have

SELECT DISTINCT city FROM sales;

-- 2. In which city we have branches

SELECT DISTINCT city,branch FROM sales;

-- 3. How many unique product lines does the data have

SELECT count(DISTINCT product_line) FROM sales;

-- 4. What is the most common payment method?

SELECT DISTINCT payment, count(payment) as count_of_payment FROM sales
GROUP BY payment
ORDER BY count_of_payment;

-- 5. what is the most selling product line

SELECT product_line, count(product_line) as most_selling_pline FROM sales
GROUP BY product_line
ORDER BY most_selling_pline DESC
limit 1;

-- 6. What is the total revenue by month

SELECT month_name,SUM(total) as total_revenue FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS

SELECT month_name, SUM(cogs) as cogs_count FROM sales
GROUP BY month_name
ORDER BY cogs_count DESC
LIMIT 1;

-- What product line had the largest revenue

SELECT product_line,SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- What is the city and branch with largest revenue

SELECT city,branch,SUM(total) as total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC
LIMIT 1;

-- What product line had the largest tax_pct

SELECT product_line, AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) as product_quantity
FROM sales
GROUP BY branch
HAVING product_quantity > (SELECT AVG(quantity) FROM sales)
ORDER BY product_quantity DESC;

-- What is the most common product line by gender

SELECT 
	gender,
	product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt;

-- 12. What is the average rating of each product line?

SELECT product_line, ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- -------------------------------------------------------------------------------
-- ----------------------------------- SALES --------------------------------------

-- 13.Number of sales made in each time of the day per weekday

SELECT time_of_day,COUNT(*) AS total_sales FROM sales
WHERE day_name = "Sunday"
GROUP BY  time_of_day
ORDER BY total_sales DESC;

-- 14. Which of the customer types bring the most revenue?

SELECT customer_type, ROUND(SUM(total),2) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has largest tax percent

SELECT city,ROUND(AVG(tax_pct),2) as tax_percent
FROM sales
GROUP BY city
ORDER BY tax_percent DESC
LIMIT 1;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;














--CREATE DATABASE
CREATE DATABASE sql_project_p2

--CREATE TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(30),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)
			
--Data Cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR 
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	;

--FINDING MEDIAN FOR NULLS 
SELECT 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) AS ssss
FROM retail_sales
LIMIT 1;

--Data Exploration

--How many sales we have ?
SELECT COUNT(*) FROM retail_sales

--How many unique customers we have ?
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales


--How many categories we have ?
SELECT COUNT(DISTINCT(category)) FROM retail_sales

--data analysis & business key problems 

--Q.1-Write sql query to retrive all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date='2022-11-05'

--Q.2-Write a SQL query to retrive all transactions where the category is clothing and
--the quantity sold is more than 4 in a month of nov-2022

SELECT 
	  *
FROM retail_sales
WHERE category='Clothing' 
AND quantity>=4
AND TO_CHAR(sale_date,'YYYY-MM')='2022-11'


--Q.3 Write SQL query to calculate the total sales (total_sale) for each category
SELECT 
	category,
	SUM(total_sale) AS total_sales,
	COUNT(*) AS total_orders
FROM
	retail_sales
GROUP BY category

--Q.4 Write SQL query to find the average age of customers who purchased items from the 'Beauty' Category.
SELECT 
	ROUND(AVG(age),2)AS avg_age
FROM retail_sales
WHERE category='Beauty'

--Q.5 Write SQL query to find all transactions where total_sale is greater than 1000
SELECT 
	*
FROM 
retail_sales 
WHERE total_sale>1000

--Q.6 Write SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(*) AS total_number_transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY 1

--Q.7 Write SQL query to calculate the average sales for each month.find out the best selling month in each year
SELECT YEAR_,MONTH_,avg_total
FROM(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS YEAR_,
	EXTRACT(MONTH FROM sale_date) AS MONTH_,
	AVG(total_sale) AS avg_total,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)  DESC) AS RNK
FROM
	retail_sales
GROUP BY 1,2
)
WHERE RNK=1

--Q.8 Write SQL query to find out the top 5 Customers based on the highest total_sales
SELECT
	customer_id,
	SUM(total_sale) AS total_sale
FROM
	retail_sales
GROUP BY 1
ORDER BY SUM(total_sale) DESC
LIMIT 5


--Q.9 Write SQL query to find the number of unique customer who purchased items for each category
SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_customer
FROM
retail_sales
GROUP BY category

--Q.10 Write SQL query to create each shift and number of orders (example morning<=12,afternoon between 12 to 17,evening>17)
WITH hourly_sale AS(
SELECT
	*,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
	WHEN EXTRACT(HOUR FROM sale_time)>17 THEN 'evening'
	ELSE 'time not available'
END AS shift
FROM
retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM
	hourly_sale
GROUP BY shift

--END OF PROJECT 














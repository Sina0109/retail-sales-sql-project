
SELECT COUNT(*) FROM retail_sales;
--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
   --
   DELETE FROM retail_sales
   WHERE 
   transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
-- Data exploration 
-- how many sales we have 
  SELECT COUNT(*) as totatl_sale FROM retail_sales
-- how many unique costimer  we have
     SELECT DISTINCT category FROM retail_sales
-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.

SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT  category, SUM(total_sale) net_sale, COUNT(*) as total_orders  FROM retail_sales GROUP BY 1

-- Q.4 Écris une requête SQL pour trouver l'âge moyen des clients qui ont acheté des articles de la catégorie 'Beauty'.
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Écris une requête SQL pour trouver toutes les transactions où total_sale est supérieur à 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Écris une requête SQL pour trouver le nombre total de transactions (transactions_id) effectuées par chaque genre dans chaque catégorie.
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;


-- Q.7 Écris une requête SQL pour calculer la vente moyenne de chaque mois. Trouve le meilleur mois de vente de chaque année.
SELECT year, month, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	Customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1 
ORDER BY 2
LIMIT 5 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example: Morning <= 12, Afternoon between 12 & 17, Evening > 17).
WITH hourly_sale
AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as Shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_sales
FROM hourly_sale
GROUP BY shift
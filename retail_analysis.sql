CREATE DATABASE retail_db;
USE retail_db;

CREATE TABLE retail_performance (
    store_id VARCHAR(20),
    store_region VARCHAR(20),
    product_category VARCHAR(50),
    product_name VARCHAR(50),
    sale_date DATE,
    quantity_sold INT,
    sales_amount DECIMAL(12,2),
    customer_footfall INT,
    inventory_units INT,
    inventory_value DECIMAL(14,2),
    inventory_turnover DECIMAL(6,2)
);
select count(*) from retail_db.retail_performance

USE retail_db;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT store_id) AS stores,
    COUNT(DISTINCT product_category) AS categories,
    MIN(sale_date) AS first_date,
    MAX(sale_date) AS last_date,
    SUM(sales_amount IS NULL) AS null_sales,
    SUM(customer_footfall IS NULL) AS null_footfall
FROM retail_performance;
SELECT
    store_id,
    store_region,
    COUNT(*) AS records,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    SUM(customer_footfall) AS total_footfall,
    ROUND(SUM(sales_amount) / SUM(customer_footfall), 2) AS sales_per_footfall
FROM retail_performance
GROUP BY store_id, store_region
ORDER BY total_sales DESC;

SELECT
    product_category,
    COUNT(*) AS records,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    ROUND(AVG(sales_amount), 2) AS avg_sales
FROM retail_performance
GROUP BY product_category
ORDER BY total_sales DESC;

SELECT
    COUNT(*) AS below_avg_records,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM retail_performance), 1) AS pct_below_avg
FROM retail_performance
WHERE sales_amount < (SELECT AVG(sales_amount) FROM retail_performance); 

USE retail_db;

CREATE TABLE stores (
    store_id VARCHAR(20) PRIMARY KEY,
    store_region VARCHAR(20)
);

INSERT INTO stores
SELECT DISTINCT store_id, store_region FROM retail_performance;

SELECT s.store_id, s.store_region,
       ROUND(SUM(r.sales_amount), 2) AS total_sales
FROM stores s
JOIN retail_performance r ON s.store_id = r.store_id
GROUP BY s.store_id, s.store_region
ORDER BY total_sales DESC;
USE EDW;

CREATE TABLE superstore (
    row_id        INT PRIMARY KEY,
    order_id      VARCHAR(20),
    order_date    VARCHAR(20),
    ship_date     VARCHAR(20),
    ship_mode     VARCHAR(30),
    customer_id   VARCHAR(20),
    customer_name VARCHAR(100),
    segment       VARCHAR(30),
    country       VARCHAR(50),
    city          VARCHAR(100),
    state         VARCHAR(100),
    postal_code   VARCHAR(20),
    region        VARCHAR(30),
    product_id    VARCHAR(30),
    category      VARCHAR(50),
    sub_category  VARCHAR(50),
    product_name  VARCHAR(300),
    sales         DECIMAL(18,4),
    quantity      INT,
    discount      DECIMAL(5,2),
    profit        DECIMAL(18,4)
);

BULK INSERT superstore
FROM 'C:\Users\PALIW\Downloads\Sample - Superstore.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'superstore';

SELECT TOP 10 * FROM superstore;

-- Region
SELECT * FROM superstore WHERE region = 'West';

-- Category
SELECT * FROM superstore WHERE category = 'Technology';

-- Order date
SELECT * FROM superstore
WHERE CAST(order_date AS DATE) BETWEEN '2014-01-01' AND '2017-01-01';

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY region;

SELECT
    product_name,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC;

SELECT
    category,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;

SELECT
    YEAR(order_date)  AS yr,
    MONTH(order_date) AS mth,
    SUM(sales)        AS monthly_sales,
    SUM(profit)       AS monthly_profit
FROM superstore
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mth;

SELECT
    TOP 5
    customer_id,
    customer_name,
    SUM(sales) AS total_purchase
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_purchase DESC;

-- Check for duplicates
SELECT
    row_id,
    COUNT(*)
FROM superstore
GROUP BY row_id
HAVING COUNT(*) > 1;

-- Check for nulls
SELECT
    *
FROM superstore
WHERE order_id = NULL OR order_date = NULL OR ship_date = NULL OR customer_id = NULL OR product_id = NULL;

SELECT
    *
FROM superstore
WHERE row_id = NULL;
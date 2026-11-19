USE EDW;

SELECT * FROM superstore;

-- 1. Create Customers/Orders/Products tables from the raw dataset.
SELECT DISTINCT customer_id, customer_name, segment
INTO customers
FROM superstore;
 
SELECT product_id, MIN(product_name) AS product_name,
       MIN(category) AS category, MIN(sub_category) AS sub_category
INTO products
FROM superstore
GROUP BY product_id;

SELECT DISTINCT order_id, customer_id, order_date, ship_date,
       ship_mode, city, state, region
INTO orders
FROM superstore;

SELECT row_id, order_id, product_id, sales, quantity, discount, profit
INTO order_items
FROM superstore;

-- 2. Use a subquery to find customers with an above-average order value.
WITH order_totals AS (
    SELECT order_id, SUM(sales) AS order_value
    FROM order_items
    GROUP BY order_id
)

SELECT o.customer_id, ROUND(AVG(ot.order_value), 2) AS customer_order_value
FROM
orders o
INNER JOIN
order_totals ot
ON o.order_id = ot.order_id
GROUP BY o.customer_id
HAVING AVG(ot.order_value) > (SELECT AVG(order_value) FROM order_totals);

-- 3. Use a CTE to compute total sales per customer.
WITH order_totals AS (
    SELECT order_id, SUM(sales) AS order_value
    FROM order_items
    GROUP BY order_id
)

SELECT o.customer_id, ROUND(SUM(ot.order_value), 2) AS total_customer_sales
FROM
orders o
INNER JOIN
order_totals ot
ON o.order_id = ot.order_id
GROUP BY o.customer_id;

-- 4. Apply ROW_NUMBER/RANK to find the top-3 orders per customer.
WITH order_totals AS (
    SELECT order_id, SUM(sales) AS order_value
    FROM order_items
    GROUP BY order_id
)

SELECT * FROM
(SELECT RANK() OVER (PARTITION BY o.customer_id ORDER BY ot.order_value DESC) AS order_rank, o.customer_id, o.order_id, ROUND(ot.order_value, 2) AS order_value
FROM
orders o
INNER JOIN
order_totals ot
ON o.order_id = ot.order_id) subquery
WHERE order_rank IN (1, 2, 3);

-- Top customers
WITH order_totals AS (
    SELECT order_id, SUM(sales) AS order_value
    FROM order_items
    GROUP BY order_id
)

SELECT TOP 3
o.customer_id, ROUND(SUM(ot.order_value), 2) AS order_value
FROM
orders o
INNER JOIN
order_totals ot
ON o.order_id = ot.order_id
GROUP BY o.customer_id
ORDER BY order_value DESC;

--  Single-order customers
WITH order_totals AS (
    SELECT order_id, SUM(sales) AS order_value
    FROM order_items
    GROUP BY order_id
)

SELECT
o.customer_id
FROM
orders o
INNER JOIN
order_totals ot
ON o.order_id = ot.order_id
GROUP BY o.customer_id HAVING COUNT(ot.order_id) = 1;
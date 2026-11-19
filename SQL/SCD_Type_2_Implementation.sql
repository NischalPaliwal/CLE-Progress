SELECT name 
FROM sys.databases;

CREATE DATABASE EDW;

USE EDW;

CREATE TABLE source_table (
    row_id        INT,
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
    profit        DECIMAL(18,4),
    start_date    DATE NOT NULL DEFAULT '2015-01-01',
    end_date      DATE NOT NULL DEFAULT '9999-12-31'
);

CREATE TABLE target_table (
    row_id        INT,
    order_id      VARCHAR(20),
    order_date    DATE,
    ship_date     DATE,
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
    profit        DECIMAL(18,4),
    start_date    DATE NOT NULL,
    end_date      DATE NOT NULL DEFAULT '9999-12-31'
);

CREATE VIEW v_source AS
SELECT row_id, order_id, order_date, ship_date, ship_mode, customer_id,
       customer_name, segment, country, city, state, postal_code, region,
       product_id, category, sub_category, product_name, sales, quantity,
       discount, profit
FROM source_table;

BULK INSERT v_source
FROM 'C:\Users\PALIW\Downloads\Sample - Superstore.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


-- FOR INITIAL LOAD
INSERT INTO target_table
SELECT row_id, order_id, order_date, ship_date, ship_mode, customer_id,
       customer_name, segment, country, city, state, postal_code, region,
       product_id, category, sub_category, product_name, sales, quantity,
       discount, profit, start_date, end_date
FROM (
    MERGE target_table AS t
    USING source_table AS s
        ON t.row_id = s.row_id AND t.end_date = '9999-12-31'

    WHEN MATCHED AND t.ship_mode <> s.ship_mode THEN
        UPDATE SET t.end_date = s.start_date

    WHEN NOT MATCHED THEN
        INSERT (row_id, order_id, order_date, ship_date, ship_mode, customer_id,
                customer_name, segment, country, city, state, postal_code, region,
                product_id, category, sub_category, product_name, sales, quantity,
                discount, profit, start_date, end_date)
        VALUES (s.row_id, s.order_id, s.order_date, s.ship_date, s.ship_mode,
                s.customer_id, s.customer_name, s.segment, s.country, s.city,
                s.state, s.postal_code, s.region, s.product_id, s.category,
                s.sub_category, s.product_name, s.sales, s.quantity, s.discount,
                s.profit, s.start_date, s.end_date)

    OUTPUT $action AS act,
           s.row_id, s.order_id, s.order_date, s.ship_date, s.ship_mode,
           s.customer_id, s.customer_name, s.segment, s.country, s.city, s.state,
           s.postal_code, s.region, s.product_id, s.category, s.sub_category,
           s.product_name, s.sales, s.quantity, s.discount, s.profit,
           s.start_date, s.end_date
) x
WHERE x.act = 'UPDATE';

UPDATE source_table
SET ship_mode = 'First Class', start_date = '2025-01-01'
WHERE row_id IN (1, 2, 3, 4);

-- FOR FURTHER LOAD (SCD TYPE 2)
INSERT INTO target_table
SELECT row_id, order_id, order_date, ship_date, ship_mode, customer_id,
       customer_name, segment, country, city, state, postal_code, region,
       product_id, category, sub_category, product_name, sales, quantity,
       discount, profit, start_date, end_date
FROM (
    MERGE target_table AS t
    USING source_table AS s
        ON t.row_id = s.row_id AND t.end_date = '9999-12-31'

    WHEN MATCHED AND t.ship_mode <> s.ship_mode THEN
        UPDATE SET t.end_date = s.start_date

    WHEN NOT MATCHED THEN
        INSERT (row_id, order_id, order_date, ship_date, ship_mode, customer_id,
                customer_name, segment, country, city, state, postal_code, region,
                product_id, category, sub_category, product_name, sales, quantity,
                discount, profit, start_date, end_date)
        VALUES (s.row_id, s.order_id, s.order_date, s.ship_date, s.ship_mode,
                s.customer_id, s.customer_name, s.segment, s.country, s.city,
                s.state, s.postal_code, s.region, s.product_id, s.category,
                s.sub_category, s.product_name, s.sales, s.quantity, s.discount,
                s.profit, s.start_date, s.end_date)

    OUTPUT $action AS act,
           s.row_id, s.order_id, s.order_date, s.ship_date, s.ship_mode,
           s.customer_id, s.customer_name, s.segment, s.country, s.city, s.state,
           s.postal_code, s.region, s.product_id, s.category, s.sub_category,
           s.product_name, s.sales, s.quantity, s.discount, s.profit,
           s.start_date, s.end_date
) x
WHERE x.act = 'UPDATE';

SELECT COUNT(*) FROM source_table;

SELECT COUNT(*) FROM target_table;
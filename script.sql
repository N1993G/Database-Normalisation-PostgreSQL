-- INSPECT THE DATA
SELECT 
  * 
FROM 
  store 
LIMIT 
  10;
-- HAVE ANY CUSTOMERS MADE MORE THAN ONE ORDER?
SELECT 
  COUNT(
    DISTINCT(order_id)
  ) 
FROM 
  store;
SELECT 
  COUNT(
    DISTINCT(customer_id)
  ) 
FROM 
  store;
-- HOW MANY ORDERS DID CUSTOMER 1 MAKE?
SELECT 
  customer_id, 
  customer_email, 
  customer_phone, 
  customer_id 
FROM 
  store 
WHERE 
  customer_id = 1;
-- HOW MANY ORDERS INCLUDE THIS ITEM AS ITEM_1?
SELECT 
  item_1_id, 
  item_1_name, 
  item_1_price 
FROM 
  store 
WHERE 
  item_1_id = 4;
-- CREATE A NORMALISATION VERSION OF THE DATABASE
CREATE TABLE customers AS 
SELECT 
  DISTINCT customer_id, 
  customer_phone, 
  customer_email 
FROM 
  store;
ALTER TABLE 
  customers 
ADD 
  PRIMARY KEY (customer_id);
CREATE TABLE items AS 
SELECT 
  DISTINCT item_1_id as item_id, 
  item_1_name as name, 
  item_1_price as price 
FROM 
  store 
UNION 
SELECT 
  DISTINCT item_2_id as item_id, 
  item_2_name as name, 
  item_2_price as price 
FROM 
  store 
WHERE 
  item_2_id IS NOT NULL 
UNION 
SELECT 
  DISTINCT item_3_id as item_id, 
  item_3_name as name, 
  item_3_price as price 
FROM 
  store 
WHERE 
  item_3_id IS NOT NULL;
ALTER TABLE 
  items 
ADD 
  PRIMARY KEY (item_id);
CREATE TABLE orders_items AS 
SELECT 
  order_id, 
  item_1_id as item_id 
FROM 
  store 
UNION ALL 
SELECT 
  order_id, 
  item_2_id as item_id 
FROM 
  store 
WHERE 
  item_2_id IS NOT NULL 
UNION ALL 
SELECT 
  order_id, 
  item_3_id as item_id 
FROM 
  store 
WHERE 
  item_3_id IS NOT NULL;
CREATE TABLE orders AS 
SELECT 
  order_id, 
  order_date, 
  customer_id 
FROM 
  store;
ALTER TABLE 
  orders 
ADD 
  PRIMARY KEY (order_id);
ALTER TABLE 
  orders 
ADD 
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE 
  orders_items 
ADD 
  FOREIGN KEY (item_id) REFERENCES items(item_id);
ALTER TABLE 
  orders_items 
ADD 
  FOREIGN KEY (order_id) REFERENCES orders(order_id);
-- QUERY THE ORIGINAL STORE TABLE AND NORMALISED TABLES TO RETURN THE EMAILS OF ALL CUSTOMERS WHO MADE AN ORDER AFTER 25 JULY 2019
SELECT 
  * 
FROM 
  store 
WHERE 
  order_date > '2019-07-25';
SELECT 
  customer_email 
FROM 
  customers, 
  orders 
WHERE 
  customers.customer_id = orders.customer_id 
  AND orders.order_date > '2019-07-25';
-- QUERY ORIGINAL STORE TABLE TO RETURN THE NUMBER OF ORDERS CONTAINING EACH UNIQUE ITEM
WITH all_items AS (
  SELECT 
    item_1_id as item_id 
  FROM 
    store 
  UNION ALL 
  SELECT 
    item_2_id as item_id 
  FROM 
    store 
  WHERE 
    item_2_id IS NOT NULL 
  UNION ALL 
  SELECT 
    item_3_id as item_id 
  FROM 
    store 
  WHERE 
    item_3_id IS NOT NULL
) 
SELECT 
  item_id, 
  COUNT(*) 
FROM 
  all_items 
GROUP BY 
  item_id;
-- IS IT EASIER OF MORE DIFFICULT TO DO WITH THE NORMALISED DATABASE TABLES?
SELECT 
  item_id, 
  COUNT(*) 
FROM 
  orders_items 
GROUP BY 
  item_id;

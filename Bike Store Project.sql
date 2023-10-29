-- drop database
DROP DATABASE IF EXISTS BikeStores;



-- CREATE DATABASE
CREATE DATABASE BikeStores;
USE BikeStores;


-- create tables
CREATE TABLE BikeStores.production_categories (
	category_id INT AUTO_INCREMENT  PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);


SELECT count(*) FROM    BikeStores.production_categories; -- 7

CREATE TABLE BikeStores.production_brands (
	brand_id INT AUTO_INCREMENT PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);
SELECT count(*) FROM  BikeStores.production_brands  ; -- 9 

CREATE TABLE BikeStores.production_products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES BikeStores.production_categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES BikeStores.production_brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);


SELECT count(*) FROM   BikeStores.production_products;-- 321
-- SELECT * FROM   production.products ,

CREATE TABLE BikeStores.sales_customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);
SELECT count(*) FROM   BikeStores.sales_customers; -- 1445

CREATE TABLE BikeStores.sales_stores (
	store_id INT AUTO_INCREMENT PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);
SELECT count(*) FROM    BikeStores.sales_stores; -- 3

CREATE TABLE BikeStores.sales_staffs (
	staff_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES BikeStores.sales_stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES BikeStores.sales_staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
SELECT count(*) FROM   BikeStores.sales_staffs; -- 10

CREATE TABLE BikeStores.sales_orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending, 2 = Processing, 3 = Rejected, 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES BikeStores.sales_customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) REFERENCES BikeStores.sales_stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES BikeStores.sales_staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
SELECT count(*) FROM    BikeStores.sales_orders  ; -- 1615

CREATE TABLE BikeStores.salesOrder_items (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES BikeStores.sales_orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES BikeStores.production_products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);
SELECT count(*) FROM   BikeStores.salesOrder_items; -- 4722

CREATE TABLE BikeStores.production_stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES BikeStores.sales_stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES BikeStores.production_products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Loading the data from csv files

LOAD DATA INFILE  
"G:/SQL_Advanced_Topics/Bike_Store_Data/salesorder_items.csv"
into table salesorder_items
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS; 


SHOW TABLES;

-- production_brands
-- production_categories
-- production_products
-- production_stocks
-- sales_customers
-- sales_orders
-- sales_staffs
-- sales_stores
-- salesorder_items


-- Stored Procedure to get the records by passing table name  
DELIMITER &&
CREATE PROCEDURE get_records(IN tab_name VARCHAR(40))
BEGIN 
	SET @sql = CONCAT('SELECT * FROM ',tab_name);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END &&

-- ------------------------------------------------------------



CALL get_records('production_brands');
CALL get_records('production_categories');
CALL get_records('production_products');
CALL get_records('sales_stores');
CALL get_records('production_stocks');
CALL get_records('sales_customers');
CALL get_records('sales_staffs');
CALL get_records('sales_orders');

CALL get_records('salesorder_items');


SHOW TABLES;
DROP TABLE sales_stores;

CALL drop_table('production_brands');
CALL drop_table('production_categories');
CALL drop_table('production_products');
CALL drop_table('sales_stores');
CALL drop_table('production_stocks');

ALTER TABLE production_stocks
DROP FOREIGN KEY stocks_ibfk_2;

ALTER TABLE child_table DROP CONSTRAINT fk_constraint_name;

DELIMITER &&
CREATE PROCEDURE get_records_count(IN tab_name VARCHAR(40))
BEGIN 
	SET @sql = CONCAT('SELECT COUNT(*) AS total_records_count FROM ',tab_name);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END && 

DROP PROCEDURE get_records_count;


DROP PROCEDURE get_distinct_records_count;

DELIMITER &&
CREATE PROCEDURE get_distinct_records_count(IN tab_name VARCHAR(40))
BEGIN 
	SET @sql = CONCAT('SELECT  DISTINCT COUNT(*) AS total_records_count FROM ',tab_name);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END && 



CALL get_records_count('production_brands'); -- 9 
CALL get_records_count('production_categories'); -- 7
CALL get_records_count('production_products'); -- 321
CALL get_records_count('production_stocks'); -- 939
CALL get_records_count('sales_customers'); -- 1445
CALL get_records_count('sales_orders'); -- 1615
CALL get_records_count('sales_staffs'); -- 10
CALL get_records_count('sales_stores'); -- 3
CALL get_records_count('salesorder_items'); -- 4722

DESC BikeStores.salesorder_items;
DESC BikeStores.sales_orders;
DESC BikeStores.production_stocks;
DESC BikeStores.sales_customers;
DESC BikeStores.production_products;
DESC BikeStores.production_brands;
DESC BikeStores.production_categories;
DESC BikeStores.sales_staffs;
DESC BikeStores.sales_stores;

DROP TABLE bikestore_master_table;

CREATE TABLE NM_CUST_SALES_ORDER_MASTER AS
SELECT DISTINCT ord.customer_id,cus.first_name, cus.last_name, ord.staff_id,
ord.store_id,str.store_name, orit.product_id,prd.product_name,prd.model_year, prd.category_id,
br.brand_name, prd.brand_id, 
orit.order_id, ord.order_status, ord.order_date, ord.shipped_date,orit.quantity,orit.list_price
FROM BikeStores.salesorder_items orit
LEFT OUTER JOIN  BikeStores.sales_orders ord ON orit.order_id = ord.order_id 
LEFT OUTER JOIN BikeStores.sales_customers cus ON ord.customer_id = cus.customer_id
LEFT OUTER JOIN BikeStores.production_stocks stc ON orit.product_id = stc.product_id
LEFT OUTER JOIN BikeStores.production_products prd ON orit.product_id = prd.product_id
LEFT OUTER JOIN BikeStores.sales_staffs stf ON ord.staff_id = stf.staff_id
LEFT OUTER JOIN BikeStores.production_brands br ON prd.brand_id = br.brand_id
LEFT OUTER JOIN BikeStores.production_categories cat ON prd.category_id = cat.category_id
LEFT OUTER JOIN BikeStores.sales_stores str ON ord.store_id = str.store_id;



DELIMITER &&
CREATE PROCEDURE get_records(IN tab_name VARCHAR(40))
BEGIN 
	SET @sql = CONCAT('SELECT * FROM ',tab_name);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END &&


DELIMITER && 
CREATE PROCEDURE get_distinct_records(IN record_name VARCHAR(30),IN `table_name`VARCHAR(40))
BEGIN
	SET @sql = CONCAT('SELECT DISTINCT ',record_name,' FROM ',`table_name`);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END &&

DROP PROCEDURE get_distinct_records;
CALL get_records('NM_CUST_SALES_ORDER_MASTER');
CALL get_distinct_records('product_name,product_id','NM_CUST_SALES_ORDER_MASTER');
CALL get_distinct_records('*','NM_CUST_SALES_ORDER_MASTER');


DELIMITER && 
CREATE PROCEDURE get_n_records(IN `column_name` VARCHAR(30),IN `table_name`VARCHAR(40),IN no_of_records INT)
BEGIN 
	SET @sql = CONCAT('SELECT ',`column_name`,' FROM ', `table_name`, ' LIMIT ', no_of_records);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
END &&

DROP PROCEDURE get_n_records;

CALL get_n_records('*','NM_CUST_SALES_ORDER_MASTER',10);

DELIMITER $$
CREATE FUNCTION calculate_total_price( quantity INT , list_price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE total_price_of_purchase DECIMAL(10,2);
    SET total_price_of_purchase = quantity*list_price;
    RETURN total_price_of_purchase ;
END $$
DELIMITER ;

-- SELECT  product_name , DENSE_RANK() OVER(PARTITION BY product_name) AS `RANK` 
-- FROM NM_CUST_SALES_ORDER_MASTER;

-- select *  , ROW_NUMBER() OVER(PARTITION BY store_name,product_name ORDER BY product_id DESC) as row_num 
-- from NM_CUST_SALES_ORDER_MASTER





-- HOW MANY ORDERS EACH CUSTOMER HAS PLACED and total quantity

SELECT customer_id,COUNT(DISTINCT order_id) AS total_orders,
SUM(quantity) AS total_quantity
FROM NM_CUST_SALES_ORDER_MASTER
GROUP BY customer_id
ORDER BY customer_id;

-- HOW MANY TOTAL ORDERS ARE THERE
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM  NM_CUST_SALES_ORDER_MASTER -- 1615 


-- HOW MANY TOTAL CUSTOMERS ARE THERE
SELECT COUNT( DISTINCT customer_id) AS TOTAL_CUSTOMERS FROM NM_CUST_SALES_ORDER_MASTER; -- 1445 



-- WHICH IS THE HIGHEST/TOP 3 SELLING  PRODUCTS ?
SELECT product_name, COUNT(DISTINCT order_id) AS no_of_orders
FROM NM_CUST_SALES_ORDER_MASTER
GROUP BY product_name
ORDER BY no_of_orders DESC
LIMIT 3
OFFSET 0;


-- GET THE LATEST AND OLDEST ORDERS 
SELECT customer_id,CONCAT(first_name,' ',last_name) AS customer_name,MIN(order_date) AS oldest_order  , MAX(order_date) AS latest_order
FROM NM_CUST_SALES_ORDER_MASTER
GROUP BY 1,2
ORDER BY 1,2; 


-- LAST 3 ORDERS DETAILS FROM EVERY CUSTOMER

SELECT customer_id,CONCAT(first_name,' ',last_name) AS customer_name, order_id, order_date
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CONCAT(first_name,' ',last_name) ) AS row_num
	FROM NM_CUST_SALES_ORDER_MASTER
) AS ordered_orders
WHERE row_num <= 3;

-- FOR EVERY CUSTOMER , TELL THE CHEAPEST PRODUCT AND THE COSTLIEST PRODUCT HE/SHE HAS BOUGHT

SELECT customer_id , CONCAT(first_name,' ',last_name) AS customer_name,product_name,product_id , 
MAX(list_price ) AS costliest_product,MIN(list_price) AS cheapest_product
FROM NM_CUST_SALES_ORDER_MASTER
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;

-- TOTAL ORDERS PRODUCT WISE WHOSE ORDERS IS MORE THAN 100
SELECT product_name , COUNT( DISTINCT order_id) AS total_orders 
FROM NM_CUST_SALES_ORDER_MASTER
GROUP BY 1
HAVING total_orders > 100
ORDER BY 2 DESC;

-- STORE WISE ORDERS
SELECT store_id,store_name , COUNT( DISTINCT order_id) AS total_orders 
FROM NM_CUST_SALES_ORDER_MASTER
GROUP BY 1,2
ORDER BY 2 DESC;

-- TO FIND TOTAL PRICE FOR EVERY CUSTOMER

----- ADDING TOTAL_PRICE BY CREATING A NEW TABLE 

CREATE TABLE NM_CUST_SALES_ORDER_MASTER_FINAL AS
SELECT *, calculate_total_price(quantity,list_price) AS TOT_PRICE
FROM   NM_CUST_SALES_ORDER_MASTER;

CALL get_records('NM_CUST_SALES_ORDER_MASTER_FINAL');

----- ADDING TOTAL_PRICE TO THE EXISTING TABLE  

ALTER TABLE NM_CUST_SALES_ORDER_MASTER
ADD COLUMN total_price DECIMAL(10,2) NOT NULL;

SET SQL_SAFE_UPDATES = 0;

UPDATE NM_CUST_SALES_ORDER_MASTER
SET total_price =  calculate_total_price(quantity,list_price)
WHERE total_price = 0.00;


--  TOTAL_PRICVE BUCKET
-- LOW_PRICE 0 -5000
-- MEDIUM_PRICE 5000 - 15000
-- HIGH_PRICE > 15000

ALTER TABLE NM_CUST_SALES_ORDER_MASTER
ADD COLUMN price_bucket VARCHAR(255) NOT NULL;


UPDATE NM_CUST_SALES_ORDER_MASTER
SET price_bucket  = (
	CASE
		WHEN 0<=total_price<5000 THEN  'Low'
        WHEN 5000<=total_price<=15000 THEN 'Medium'
        ELSE 'High'
	END
)
WHERE price_bucket = '';

CALL get_records('NM_CUST_SALES_ORDER_MASTER');

SELECT * FROM NM_CUST_SALES_ORDER_MASTER
WHERE price_bucket = 'Low';


-- READING NULL VALUES

SELECT * FROM NM_CUST_SALES_ORDER_MASTER WHERE price_bucket IS NULL;  -- NO NULL VALUES
 
-- READING COMPLETELY EMPTY/BLANK ROWS

SELECT * FROM NM_CUST_SALES_ORDER_MASTER WHERE price_bucket = ''; 

UPDATE  NM_CUST_SALES_ORDER_MASTER
SET total_price = 0.00;
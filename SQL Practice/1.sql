SELECT first_name, last_name
FROM customers;
-- EXERCISE
SELECT name,unit_price, (unit_price*1.1)as 'new price'
FROM products;
SELECT  DISTINCT state
FROM customers;

-- Get the order placed this year
SELECT * FROM orders
where order_date LIKE '2019%';

SELECT * FROM order_items
WHERE (order_id=6 AND quantity*unit_price>30);
-- =============
-- IN OPERATOR
SELECT * FROM customers
where state IN('LA','VA','FL','GA');

-- IN or
-- between and
SELECT *  FROM products
where quantity_in_stock IN(49,38,72); 
 
 SELECT * From customers
 where birth_date BETWEEN'1990-01-01'AND '2000-01-01';

SELECT * FROM customers
where (address LIKE ('%TRAIL%') OR address LIKE('%AVENUE')
)AND phone NOT LIKE('_________9');
-- ------
-- REGEXP
-- ^ must start with
-- $ must end with 
-- | or
-- [] previous character choices 
-- [a-h]

SELECT * from customers
-- where first_name REGEXP '^ELKA|^AMBUR' ;
-- where last_name REGEXP '^MY|SE' ;
where last_name REGEXP 'B[RU]' ;
SELECT * FROM orders 
where shipped_date IS NULL;
SELECT * FrOM customers
ORDER BY state ASC, first_name DESC;
SELECT first_name, last_name
FROM  customers
ORDER BY 1,2;


SELECT * FROM order_items
WHERE order_id=2
ORDER BY quantity*unit_price DESC;

-- LIMIT
SELECT * FROM 
customers
LIMIT 3;
-- LIMIT 6,3 skip first 6 and pick next 3
SELECT * FROM 
customers
LIMIT 6,3;

SELECT * FROM customers
order BY points DESC
LIMIT 3;

-- --- 
-- placed order inner joins
SELECT * FROM orders
INNER JOIN customers
ON orders.customer_id=customers.customer_id;
 
 
 SELECT order_id,o.product_id,quantity,o.unit_price name FROM order_items o 
 INNER JOIN products p
 ON o.product_id=p.product_id
 GROUP BY order_id;
 
 SELECT * FROM order_items o
 JOIN sql_inventory.products p
 ON o.product_id=p.product_id;
 -- self join
 SELECT e1.employee_id , e1.first_name,e2.first_name
 FROM employees e1 JOIN employees e2
 ON e1.employee_id=e2.reports_to;
 
 SELECT * FROM orders
JOIN customers
ON orders.customer_id=customers.customer_id
JOIN order_statuses t
ON t.order_status_id=orders.status;


SELECT p.payment_id,c.name
FROM payments  p
JOIN clients c
using (client_id);
-- JOIN payment_methods pp

-- ON p.payment_method=pp.payment_method_id;
 
 -- COMPOUND JOIN 
 -- using or and operator in on statement
 
 
 SELECT oi.product_id,p.name  , oi.quantity
 FROM order_items oi
 RIGHT JOIN products p
 ON p.product_id=oi.product_id;
 SELECT o.order_date,o.order_id, c.first_name , s.name,os.name

FROM orders o
 LEFT JOIN customers c
USING(customer_id)
 LEFT JOIN shippers s
USING (shipper_id)
 JOIN order_statuses os
ON o.status=os.order_status_id;
 
 SELECT * FROM sql_invoicing.payments;
SELECT p.date,c.name,p.amount,pm.name
FROM payments p 
JOIN clients c
USING (client_id)
JOIN payment_methods pm
ON p.payment_method=pm.payment_method_id;
SELECT * FROM sql_store.customers;
SELECT customer_id,first_name,points,'BRONZE' AS TYPE
FROM customers
WHERE points<2000
UNION
SELECT customer_id,first_name,points,'SILVER' AS TYPE
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id,first_name,points,'GOLD' AS TYPE
FROM customers
WHERE points>3000;
-- DEfault 
-- generates default value of primary key or generates default set values
SELECT * FROM sql_store.products;
-- Insert 3 rows in products table
INSERT INTO products 
VALUES(DEFAULT,
'MUKUL',90,0.5
),(DEFAULT,
'MUKUL',90,0.5
),(DEFAULT,
'MUKUL',90,0.5
);
-- Last_Insert_ID(); return id of last value
SELECT * FROM sql_invoicing.invoices;
CREATE TABLE invoices_archived AS
SELECT  i.invoice_id, c.name FROM invoices i
JOIN clients c
USING(client_id)
WHERE payment_date IS NOT NULL;

-- COUNT not include null values
-- COUNT(*) includes null value too
-- COUNT (DISTINCT client_id)

SELECT p.date,pp.name,SUM(p.amount)
FROM payments p  
JOIN payment_methods pp 
ON p.payment_method=pp.payment_method_id
GROUP BY pp.name,p.date
order by p.date;

SELECT c.first_name,
sum(oi.quantity*oi.unit_price) as 'PRICE'
FROM orders o
JOIN customers c
USING (customer_id)
JOIN 
order_items oi
USING(order_id)
where c.state='VA'
group by c.first_name,payments  with rollup
HAVING ( PRICE>100);


-- WITH ROLLUP
 SELECT pp.name,
SUM(p.amount) as'AMOUNT'
FROM payment_methods pp 
JOIN payments p 
ON p.payment_method=pp.payment_method_id
GROUP BY pp.name with ROLLUP;

-- sub queries
Use sql_hr;
-- ques find all employees that earn more then average
Select * from employees
WHERE salary>(Select AVG(salary)
FROM employees
);
-- -----------------------------------------------------
-- IN OPERATOR
-- Product that has never been ordered 
Use sql_store;
SELECT name 
FROM products
WHERE product_id
NOT IN(SELECT DISTINCT product_id
FROM order_items);

-- Find clients without invoices
SELECT name 
FROM  clients
WHERE client_id
NOT IN(
SELECT DISTINCT client_id FROM invoices);
-- Question - Find all customers who have ordered lettuce (product_id =3) using subquery and then JOIN 
-- SUB QUERY
SELECT customer_id, first_name , last_name
FROM customers
WHERE customer_id IN(SELECT customer_id
FROM orders
 WHERE
order_id IN(
SELECT 
order_id FROM order_items
WHERE product_id=3));

-- using joins
SELECT  DISTINCT customer_id, first_name,last_name
FROM customers
 JOIN orders o
USING(customer_id)
 JOIN order_items oi
USING (order_id)
WHERE oi.product_id=3;
-- JOINS ARE MORE READABLE THIS TIME
-- ques SELECT INVOICES OF ALL  invoices GREATER THAN INVOICES OF CLIENT 3  
USE sql_invoicing;
-- without all keyword
SELECT invoice_total
FROM invoices
WHERE invoice_total>(
SELECT MAX(invoice_total)
FROM invoices
WHERE client_id=3);
-- with all key word
-- USING all keyword check the subquery for array of values
SELECT * 
FROM invoices
WHERE invoice_total>ALL(
SELECT invoice_total
FROM invoices
WHERE client_id=3
);
-- ANY keyword or SOME KEYWORD
-- opposite to all , instead of all check for any
-- can be used in place of in =ANY
-- QUES  Select clients with atleast two invoices
-- WITHOUT ANY USING IN KEYWORD
SELECT * FROM
clients
WHERE client_id IN(
SELECT client_id 
FROM invoices
GROUP BY(client_id)
having COUNT(invoice_id)>=2);
-- WITH ANY OR SOME KEYWORD
SELECT * FROM
clients
WHERE client_id =SOME(
SELECT client_id 
FROM invoices
GROUP BY(client_id)
having COUNT(invoice_id)>=2);
-- -----------------------------------

-- CORELATED SUB QUERY
-- one query dependent on other query or sub query
-- subquery gets executed more time than normal sub query 
-- so corelated are slow and acquire more data

-- ques find the employee from same office whose salary is greater the avg salary of the office
SELECT * FROM employees e
WHERE salary>(
SELECT AVG(salary)
FROM employees
WHERE office_id=e.office_id);
-- ques  ivoices larger than  clients average invoice amount
SELECT *  FROM 
invoices i
where invoice_total>(
SELECT AVG(invoice_total)
FROM invoices 
WHERE client_id=i.client_id
);
-- EXIST OPERATOR
-- return true or false
-- ques find the products that has never been ordered
-- faaster than in

-- using in
SELECT * FROM products
WHERE product_id NOT IN(SELECT DISTINCT product_id
FROM order_items);

-- using exist keyword
SELECT * FROM products p
WHERE NOT EXISTS (SELECT DISTINCT product_id
FROM order_items
WHERE product_id=p.product_id
);
-- SELECT (SUBQUERY)

-- SELECT CLIENTID , name,total_sales,avg , differenced
SELECT client_id,name,(
SELECT SUM(invoice_total)
FROM invoices
WHERE c.client_id=client_id
) AS total_sales,
(SELECT AVG(invoice_total)
FROM invoices) AS average,
(SELECT total_sales)-(SELECT average) as difference 
                          -- totalsales and average can not be used directly
                         -- these can be used in two ways either by writing the whole query for average and total 
					     -- or using type alias
FROM clients c;
-- SUBQUERY IN FROM CLAUSE

-- to perform operations like where or join  on the subquery there subquery is used in from clause
-- the same task can be done using views 
-- **********************************IMPortant*****************************
-- "SUBQUERY SHOULD BE PROVIDED ALIAS NAMES "--
SELECT * FROM (
SELECT client_id,name,(
SELECT SUM(invoice_total)
FROM invoices
WHERE c.client_id=client_id
) AS total_sales,
(SELECT AVG(invoice_total)
FROM invoices) AS average,
(SELECT total_sales)-(SELECT average) as difference
FROM clients c
) AS sub
where client_id=1;
-- ***********************************************************************************
-- FUNCTIONS IN MYSQL
-- NUMERIC
-- ROUND(5.6)
-- ROUND(6.64,1) // 6.7  one digit precison
-- TRUNCATE(5.7345,2) // output 5.73
-- CEILING(5.73) -- 6
-- FLOOR(), ABS() , RAND() -- genrates random value between 0 to 1
-- STRING FUNCTION 
-- LENGTH(), UPPER(),LOWER()
-- LTRIM() - trim left spaces
-- RTRIM()
-- TRIM=ltrim+rtrim
-- LEFT("MUKUL",1)--output M
-- RIGHT("MUKUL",2) -- output LU
-- SUBSTRING("STRING",2,3)-- TRI  3 is number of character
-- LOCATE('H',"HELLO") -- 1 search same for both upper and lower 0 for -1
-- REPLACE("","")
-- CONCAT("","")
-- --------------------------
-- DATE FUNCTIONS
-- NOW   date and type
-- CURDATE()
-- CURTIME()
-- YEAR(NOW())
-- MONTH(NOW()) -- return integers
-- DAYNAME(NOW()) -- return String
-- EXTRACT(DAY FROM NOW())

SELECT DATE_FORMAT(NOW(), '%y'); -- 21
SELECT DATE_FORMAT(NOW(), '%Y'); -- 2021
SELECT DATE_FORMAT(NOW(), '%m'); -- 01
SELECT DATE_FORMAT(NOW(), '%M'); -- JANUARY
SELECT DATE_FORMAT(NOW(), '%d'); -- 25
SELECT DATE_FORMAT(NOW(), '%D'); -- 25th
SELECT DATE_FORMAT(NOW(), '%D %M %Y'); -- 25th January 2021
SELECT TIME_FORMAT(NOW(), '%H'); -- 13 24hr format
SELECT TIME_FORMAT(NOW(), '%h'); -- 1
SELECT TIME_FORMAT(NOW(), '%i'); -- minutes s for seconds p for pm
SELECT TIME_FORMAT(NOW(), '%H:%i %p');
-- ***************************************************************************************
-- IFNULL ELSE 
SELECT order_id, IFNULL(shipper_id,"NOT ASSIGNED") AS shipped,IFNULL(shipped_date,"NOT SHIPPED YET") as date
FROM orders;
-- COSALESCE Function
SELECT order_id, COALESCE(shipper_id,comments,"NOT ASSIGNED") AS shipped,IFNULL(shipped_date,"NOT SHIPPED YET") as date
FROM orders;
-- Coalesce assigns first not null member of comments in shipper_id , if comments is also null then not assigned

-- QUES   display all customers alpong with their full name and phone number from customers table in sql_store
SELECT CONCAT(first_name,' ',last_name) as Full_Name,
IFNULL(phone,"UNKNOWN") as phone_no
FROM customers;
-- IF FUNCTION

-- IF(EXPRESSION , COND2,COND2)
-- checking if the current year equal to present year then it is active
SELECT order_id,
order_date,
IF(
YEAR(order_date)=
Year(NOW()),
"ACTIVE","INACTIVE") AS statuus
FROM orders;
-- QUES product_id, name , number of time order has been placed, ONCE MANY TIMES ....
SELECT product_id, name,
COUNT(o.order_id) as orders,
IF(count(o.order_id)=1,"ONCE","MANY TIMES")
FROM products
JOIN order_items o
using(product_id)
GROUP BY(product_id);
--  CASE OPERATOR   JUST AS SWITCH 
-- CASE 
 --    WHEN (CONDITION ) then statement
 --    WHEN                
 --    ELSE   -- just like default
 -- no , after every case of when then
-- END AS CATEGORY -- to end case operator
-- QUES DIFferntiate all the customers to GOLD SILVER AND BRONZE on the basis of their points
SELECT first_name, 
points,
CASE
  WHEN (points>3000) THEN "GOLD"
  WHEN( points>=2000) THEN "SILVER"
  ELSE "BRONZE"
END AS STATUS  
FROM customers;



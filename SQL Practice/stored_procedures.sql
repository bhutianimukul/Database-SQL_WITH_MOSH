 -- STORED PROCEDURES or Function
 -- contains block of sql code 
 -- store sql code 
 -- code in stored procedures are optimized
 -- provides data security
 -- CREATE STORED PROCEDURES
 
 DELIMITER $$
 CREATE PROCEDURE get_clients()
 BEGIN
 SELECT * from clients; --  there is need to change the delimter to something else because my sql terminate on seeing ;
 END$$
 DELIMITER ;

 
CALL get_clients();
-- QUES Create a stored procedure get_invoices_with_balance invoices with balance>0
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
SELECT * FROM invoices 
WHERE invoice_total-payment_total>0;
END$$
CALL get_invoices_with_balance();
DROP PROCEDURE IF EXISTS get_clients;  -- if exists shows whether stored procedure exists or not
-- passing parameters

 DELIMITER $$
 CREATE PROCEDURE get_clients_with_states(state char(2))
 BEGIN
 SELECT * from clients c
 WHERE c.state=state; --  there is need to change the delimter to something else because my sql terminate on seeing ;
 END$$
 DELIMITER ;

CALL get_clients_with_states("CA");

-- QUES
-- CREATE STORED PROCEDURE FOR GIVEN CLIENTS to return invoices
DELIMITER $$
CREATE PROCEDURE get_invoices_with_clients(name varchar(10))
BEGIN
SELECT * FROM invoices i
JOIN clients c
USING(client_id)
WHERE c.name=name;
 END$$
 DELIMITER ;
 CALL get_invoices_with_clients("Vinte");
  CALL get_invoices_with_clients("VINTE"); --  parameters here are not case sensitive
  DROP PROCEDURE get_invoices_with_clients;
--     **************************************
-- MAKING DEFAULT PARAMETER
DELIMITER $$
CREATE PROCEDURE get_invoices_with_clients(name varchar(10))
BEGIN
    IF name IS NULL THEN SET name="VINTE";
    END IF;            -- if user does not provide anything then if is executed if need to be ended too
SELECT * FROM invoices i
JOIN clients c
USING(client_id)
WHERE c.name=name;
 END$$
 DELIMITER ;

-- updation data in STORED PROCEDURE
DELIMITER $$
CREATE PROCEDURE make_payment(
invoice_id INT, 
payment_amount DECIMAL(9,2),
payment_date DATE)
BEGIN
IF payment_amount<=0 THEN SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT=" INVALID" ;
END IF; --  to validate data if conditon is used so , it will raise exception and print message invalid 22003 is sql state exception for data format
UPDATE invoices i
SET i.payment_total=payment_amount,
i.payment_date=payment_date
WHERE i.invoice_id=invoice_id;
END $$
DROP PROCEDURE make_payment$$
CALL make_payment();
-- _______________________________________________________________________________________________________--
-- returning values
DELIMITER $$
CREATE PROCEDURE get_unpaid_invoice_for_client(client_id INT,
OUT invoices_count INT,         -- output parameters
OUT invoices_total DECIMAL(9,2))
BEGIN
SELECT COUNT(*),SUM(invoice_total)
INTO invoices_count , invoices_total -- to pass the values to out put parameters
FROM invoices i
WHERE i.client_id=client_id AND payment_total=0;
END$$
CALL get_unpaid_invoice_for_client(5);

-- USER VARIABLE 
SET @a=0; used for getting output from stored procedure 
-- :LOCAL 
DECLARE a INT; -- defined inside stored procedure
-- FUNCTION it can return only single value stored procedure can return result set
CREATE FUNCTION get_risk(client_id INT)
RETURN INT
-- DETERMINISTIC  return same output for same input
-- READ SQL DATA only select
-- MODIFY only modify
-- SELECT MODIFY SQL DATA
READ SQL DATA
SELECT 
BEGIN
END








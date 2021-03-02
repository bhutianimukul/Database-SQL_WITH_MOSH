-- TRIGGERS GETS EXECUTED before or after insert or update
DELIMITER $$
CREATE TRIGGER insert_after_payment
AFTER INSERT ON payments      -- after insering in payment table
FOR EACH ROW                  -- row level trigger gets executed on every row  -- multiple times
BEGIN
UPDATE invoices
SET payment_total=NEW.amount -- NEW is used to access the new value inserted also old can be used 
WHERE invoice_id=invoice_id+new.invoice_id; 
END $$
-- ON Execution of this trigger after every execution of insert in payments invoice table gets updated
-- TRIGGER CAN NOT RETURN RESULT SET 

-- QUES trigger that fires when payment is deleted it should reduce the payment total
DROP TRIGGER If EXISTS onDELETE ;
DELIMITER $$
CREATE TRIGGER onDelete
AFTER DELETE ON payments
For Each ROW
BEGIN
UPDATE invoices 
SET payment_total=payment_total-old.amount
WHERE invoice_id=old.invoice_id;
END $$ 
SHOW TRIGGERS;
-- **********************************************
-- TRIGGER CAN ALSO BE USED IN AUDITING
-- Inserting into audit file to see who made changes when and what changes are maid
USE sql_invoicing; 

CREATE TABLE payments_audit
(
	client_id 		INT 			NOT NULL, 
    date 			DATE 			NOT NULL,
    amount 			DECIMAL(9, 2) 	NOT NULL,
    action_type 	VARCHAR(50) 	NOT NULL,
    action_date 	DATETIME 		NOT NULL
)
DELIMITER $$
DROP TRIGGER If EXISTS insert_after_payment $$
CREATE TRIGGER insert_after_payment
AFTER INSERT ON payments      -- after insering in payment table
FOR EACH ROW                  -- row level trigger gets executed on every row  -- multiple times
BEGIN
UPDATE invoices
SET payment_total=NEW.amount -- NEW is used to access the new value inserted also old can be used 
WHERE invoice_id=invoice_id+new.invoice_id; 
INSERT INTO payments_audit
VALUES(new.client_id,NEW.DATE,NEW.AMOUNT,"INSERT",NOW());
END $$




DELIMITER $$
DROP TRIGGER If EXISTS onDelete$$
CREATE TRIGGER onDelete
AFTER DELETE ON payments
For Each ROW
BEGIN
UPDATE invoices 
SET payment_total=payment_total-old.amount
WHERE invoice_id=old.invoice_id;
INSERT INTO payments_audit
VALUES(old.client_id,OLD.DATE,OLD.AMOUNT,"DELETE",NOW());
END $$ 
SHOW triggers;

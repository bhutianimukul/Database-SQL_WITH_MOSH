START TRANSACTION;
INSERT into orders(customer_id,order_date,status)
VALUES(1,'27-01-21',1);
INSERT INTO order_items
VALUES(last_insert_id(),1,1,1);
COMMIT;
-- if there is single line my sql auto commits
-- EVERY SINGLE STATEMENT IN MY SQL IS AUTOCOMMIT

-- CONCURRENCY
-- two user access data on same time and perform modify

START TRANSACTION;
UPDATE customers
SET points=points+10
WHERE customer_id=1;
COMMIT;
-- CONCURRENCY - When we have mutliple transactions going in parallel
               -- CONCURRENCY problems occurs when different users try to modify or retrive data at same time
               -- MySQL provides LOCKING of transactions for CONCURRENCY control
               
			-- LOST UPDATE WRITE WRITE
            -- if two transaction are concurrent then the change made by the first commited transaction would be lost
            -- eg
           -- transaction 1 is changing state
           -- transaction 2 is changing points of the customers 
-- if transaction 2 is commited at last then the state changed by the transaction 1 would be lost ansd set to the changes made by transaction 2
-- SOLUTION USE LOCK

-- DIRTY READS
-- when a transaction reads corrupted data 
-- eg if transaction 1 chamges points and transaction 2 read points  and then transaction 1 rool back
-- WRITE READ PROBLEM
-- STANDArd level mysql has defined

-- NON REPEATABLE READ
-- different value read in different read
-- READ WRITE
-- ISOLATION STANDARD REPEATABLE READ

-- PHANTOM READ
-- GHOST READ
-- example transaction 1 is selecting customers with more than 10 points 
-- transaction 2 update the customer and one customer points are now greater than 10 but stiill he is not in the list of customers whose value is greater than 10
-- SOLUTION SERIALIZABILITY

-- ISOLATION LEVELS
-- DEFAULT IS REPEATABLE READ IN MYSQL
-- READ UNCOMMMITED          HIGH CONCURRENCY    FASTER ,NO LOCK,ALL CONCURRENCY
-- READ COMMITTED            only dirty read
-- REPEATABLE READ           CAN NOT CURE PHANTOME READ
-- SERIALIBLE                    
-- DEFAULT ISOLATION LEVEL

SHOW VARIABLES LIKE"transaction_isolation";
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;  -- session
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;   -- globally



-- READ UNCOMMITTED










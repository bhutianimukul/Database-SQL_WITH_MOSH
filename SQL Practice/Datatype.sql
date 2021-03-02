-- String
-- char(x)
-- varchar(x)
-- MediumText
-- LongText
-- TinyText
-- Text
-- INTEGER     4 bytes

-- UnSIGNED TinyInt 0 to 255
-- MediumInt
-- BigInt  8 bytes
-- ***********************
-- DECIMAL(p,s) precision, scale(after decimal)
-- DEC
-- Numeric
-- Fixed 

-- DOUBLE
-- FLOAT
-- BOOLEAN TRUE FALSE
-- ***************************************************************************8
-- ENUM
-- enum("hello","hi","bye") 
-- SET(" " ,"" ,"" )
-- DATE
-- TIME 
-- DATETIME   8bytes
-- TIMESTAMP  4bytes year 2038 problem
-- YEAR
-- BLOB --binary
-- 1. TINYBLOB 255bytes
-- 2   BLOB      
-- 3 MEDIUMBLOB
-- 4 LONGBLOB
-- ******************************************************************************8
-- storing JSON objects
UPDATE products
SET properties= '{
"dimensions" : [1,2,3],
"weight" : 20,
"manufactured" : {"name":"sony"
} 
}'
where product_id=1;

UPDATE products
SET properties= JSON_OBJECT(
"dimensions" , JSON_ARRAY(1,2,3),
"weight" , 20,
"manufactured" , JSON_OBJECT("name","SONY")
 
)
where product_id=1;

 
 -- EXTRACTION VALUE FROM KEY 
 -- USING JSON EXTRACT
 -- first parameter is field name , second parameter has a string $ represent current document while . weight extracts
 -- -> parse operator
 SELECT product_id,properties->'$.weight'
 FROM sql_store.products;
 -- JSON SET
 



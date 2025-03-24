-- CHECKS

SELECT COUNT(customer_id)
FROM cafe_offers.customers;
-- there's 17000 customers

SELECT COUNT(DISTINCT customer_id)
FROM cafe_offers.customers; 
-- making sure these match so all customers are unique

SELECT COUNT(DISTINCT customer_id)
FROM cafe_offers.events_table;
-- there's also 17000 unique customers in this table

SELECT COUNT(DISTINCT events_table.customer_id)
FROM cafe_offers.events_table
INNER JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id;
-- result was 16999 so there's a customer id that may be incorrect in events table

SELECT * 
FROM cafe_offers.events_table
LEFT JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
WHERE customers.customer_id IS NULL;
-- customer id 25656382424241009698120962046477 is the problem

SELECT * 
FROM cafe_offers.customers
LEFT JOIN cafe_offers.events_table ON events_table.customer_id = customers.customer_id
WHERE events_table.customer_id IS NULL;
-- was changed to '2.5656382424241E+031' in spreadsheet software most likely

UPDATE cafe_offers.customers
SET customers.customer_id = '25656382424241009698120962046477'
WHERE customer_id = 2.5656382424241E+031;
-- fixing customer id

SELECT COUNT(*), age
FROM cafe_offers.customers
GROUP BY age
ORDER BY age ASC;
-- we see unusual number of customers of age 118

SELECT AVG(income)
FROM cafe_offers.customers
WHERE age = 118;

SELECT age, COUNT(*)
FROM cafe_offers.customers
WHERE income = 0
GROUP BY age;
-- these two queries show us that all of 118yo customers have missing income data
-- and all the missing income data is for customers that are 118yo

SELECT ROUND(SUM(amount), 2)
FROM cafe_offers.events_table;
-- total sales is $1 775 451.97

SELECT ROUND(SUM(amount), 2)
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
WHERE customers.age = 118;
-- missing data customers makes up $40 509.57 of sales

SELECT COUNT(*)
FROM cafe_offers.events_table
WHERE event_occured = 'transaction';
-- 138 953 total transactions

SELECT COUNT(*)
FROM cafe_offers.events_table
WHERE event_occured = 'offer completed';
-- 33 579 offers completed

SELECT COUNT(*)
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
WHERE customers.age = 118 AND event_occured = 'transaction';
-- 14 996 transactions for 118 group

SELECT COUNT(*)
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
WHERE customers.age = 118 AND event_occured = 'offer completed';
-- 1 135 offers completed for 118 group

SELECT gender, COUNT(*)
FROM cafe_offers.customers
WHERE age = 118
GROUP BY gender;
-- missing gender for all of 118 group as well

SELECT COUNT(DISTINCT customers.customer_id)
FROM cafe_offers.customers
JOIN cafe_offers.events_table ON events_table.customer_id = customers.customer_id
WHERE events_table.event_occured LIKE '% completed';
-- 12 774 customers have completed at least one offer
-- leaving 4226 customers without any offers completed

ALTER TABLE customers
ADD COLUMN offers_completed INT DEFAULT 0;
-- new column for offers completed

UPDATE customers
JOIN (
	SELECT customer_id,
		COUNT(*) AS offer_completed_count
	FROM cafe_offers.events_table
    WHERE event_occured LIKE '%completed'
    GROUP BY customer_id
) complete_count
SET offers_completed = complete_count.offer_completed_count
WHERE customers.customer_id = complete_count.customer_id;
-- populating new column with data

SELECT COUNT(*)
FROM cafe_offers.customers
WHERE offers_completed > 0;
-- matches 12 774 customers from before

SELECT COUNT(DISTINCT customer_id)
FROM cafe_offers.events_table
WHERE event_occured = 'transaction';
-- 16 578 customers have made at least one transaction

ALTER TABLE customers
ADD COLUMN transactions_completed INT DEFAULT 0;
-- adding column for number of transactions made

UPDATE customers
JOIN (
	SELECT customer_id,
		COUNT(*) AS transaction_count
	FROM cafe_offers.events_table
    WHERE event_occured = 'transaction'
    GROUP BY customer_id
) complete_count
SET transactions_completed = complete_count.transaction_count
WHERE customers.customer_id = complete_count.customer_id;
-- populating new column

SELECT COUNT(*)
FROM cafe_offers.customers
WHERE transactions_completed > 0;
-- matches 16 578 from before
-- Insights

-- Revenue breakdown
SELECT
	CASE
		WHEN customers.income > 0 AND customers.income <= 50000 THEN 'low income'
        WHEN customers.income > 50000 AND customers.income <= 90000 THEN 'medium income'
        WHEN customers.income > 90000 THEN 'high income'
        ELSE '118'
	END AS income_bins,
    ROUND(SUM(events_table.amount), 0) AS 'revenue',
    ROUND(SUM(events_table.amount) / (SELECT SUM(amount) FROM cafe_offers.events_table) * 100, 2)  AS revenue_percentage
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
GROUP BY income_bins;

-- Spending Habits
SELECT 
	CASE
		WHEN customers.income > 0 AND customers.income <= 50000 THEN 'low income'
        WHEN customers.income > 50000 AND customers.income <= 90000 THEN 'medium income'
        WHEN customers.income > 90000 THEN 'high income'
        ELSE '118'
	END AS income_bins,
    COUNT(DISTINCT customers.customer_id) AS 'population',
	COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'transaction' THEN 1 END) AS transactions_completed,    
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) /
		COUNT(DISTINCT customers.customer_id), 2) AS 'offers_completed_per_customer',
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'transaction' THEN 1 END) /
		COUNT(DISTINCT customers.customer_id), 2) AS 'transactions_per_customer',
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) / 
		COUNT(CASE WHEN events_table.event_occured = 'transaction' THEN 1 END) * 100, 2) AS offer_rate
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
GROUP BY income_bins
ORDER BY offer_rate DESC;

-- Average spent per visit
SELECT 
	CASE
		WHEN customers.income > 0 AND customers.income <= 50000 THEN 'low income'
        WHEN customers.income > 50000 AND customers.income <= 90000 THEN 'medium income'
        WHEN customers.income > 90000 THEN 'high income'
        ELSE '118'
	END AS income_bins,
    ROUND(SUM(events_table.amount) /
		COUNT(CASE WHEN events_table.event_occured = 'transaction' THEN 1 END), 2) AS average_spent_per_visit,
	ROUND(SUM(events_table.amount), 0) AS 'revenue',
    ROUND(SUM(events_table.amount) / (SELECT SUM(amount) FROM cafe_offers.events_table) * 100, 2)  AS revenue_percentage
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
GROUP BY income_bins
ORDER BY average_spent_per_visit DESC;

-- Completion rate of offers based on difficulty and income
SELECT offers.difficulty,
	COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) /
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) * 100, 2) AS completion_rate
FROM cafe_offers.events_table
JOIN cafe_offers.offers ON offers.offer_id = events_table.offer_id
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
-- WHERE offers.difficulty > 0 AND customers.income > 0 -- ALL EXCEPT '118' GROUP
-- WHERE offers.difficulty > 0 AND customers.income > 0 AND customers.income <= 50000 -- LOW INCOME
-- WHERE offers.difficulty > 0 AND customers.income > 50000 AND customers.income <= 90000 -- MEDIUM INCOME
WHERE offers.difficulty > 0 AND customers.income > 90000 -- HIGH INCOME
GROUP BY offers.difficulty
ORDER BY offers.difficulty;

-- Completion rate of each offer
SELECT events_table.offer_id, 
	offers.offer_type,
	offers.reward,
    offers.difficulty,
	COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) /
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) * 100, 2) AS completion_rate 
FROM cafe_offers.events_table
JOIN cafe_offers.offers ON offers.offer_id = events_table.offer_id
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
WHERE offers.difficulty > 0 AND customers.age < 118
GROUP BY events_table.offer_id, offers.reward, offers.difficulty, offers.offer_type
ORDER BY completion_rate DESC;

-- Completion rate based on age
SELECT 
	CASE
		WHEN customers.age BETWEEN 18 AND 29 THEN '18-29'
        WHEN customers.age BETWEEN 30 AND 45 THEN '30-45'
        WHEN customers.age BETWEEN 46 AND 64 THEN '46-64'
        WHEN customers.age BETWEEN 65 AND 117 THEN '65+'
        ELSE 'Other'
	END AS age_bins,
    COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) /
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) * 100, 2) AS completion_rate
FROM cafe_offers.events_table
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
GROUP BY age_bins;

-- Completion rate of offers based on difficulty and age
SELECT offers.difficulty,
	COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) /
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) * 100, 2) AS completion_rate
FROM cafe_offers.events_table
JOIN cafe_offers.offers ON offers.offer_id = events_table.offer_id
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
-- WHERE offers.difficulty > 0 AND customers.age > 0 AND customers.age < 118 -- ALL EXCEPT '118' GROUP
-- WHERE offers.difficulty > 0 AND customers.age > 17 AND customers.age <= 29 -- 18-29
-- WHERE offers.difficulty > 0 AND customers.age > 29 AND customers.age <= 45 -- 30-45
-- WHERE offers.difficulty > 0 AND customers.age > 45 AND customers.age <= 64 -- 46-64
WHERE offers.difficulty > 0 AND customers.age > 64 AND customers.age < 118 -- 65+
GROUP BY offers.difficulty
ORDER BY offers.difficulty;

-- Offer visibility and completion rates
SELECT offers.offer_id,
	web,
    email,
    mobile,
    social,
    COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END) AS offers_viewed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) 
		/ COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END), 2) AS view_conversion
FROM cafe_offers.offers
JOIN cafe_offers.events_table ON events_table.offer_id = offers.offer_id
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
-- WHERE customers.age < 118 -- ALL INCOME 
-- WHERE customers.age < 118 AND customers.income > 90000 -- HIGH INCOME
-- WHERE customers.age < 118 AND customers.income > 50000 AND customers.income <= 90000 -- MEDIUM INCOME
WHERE customers.age < 118 AND customers.income <= 50000 -- LOW INCOME
GROUP BY offers.offer_id, web, email, mobile, social
ORDER BY offers_viewed DESC;

-- Offer visibility vs income
SELECT offers.offer_id,
	web,
    email,
    mobile,
    social,
    COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END) AS offers_viewed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END) 
		/ COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END), 2) AS view_rate
FROM cafe_offers.offers
JOIN cafe_offers.events_table ON events_table.offer_id = offers.offer_id
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
-- WHERE customers.age < 118 -- ALL INCOME 
-- WHERE customers.age < 118 AND customers.income > 90000 -- HIGH INCOME
WHERE customers.age < 118 AND customers.income > 50000 AND customers.income <= 90000 -- MEDIUM INCOME
-- WHERE customers.age < 118 AND customers.income <= 50000 -- LOW INCOME
GROUP BY offers.offer_id, web, email, mobile, social
ORDER BY offer_id;

-- Offer visibility vs age
SELECT offers.offer_id,
	web,
    email,
    mobile,
    social,
    COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END) AS offers_viewed,
    COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END) AS offers_received,
    ROUND(COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END) 
		/ COUNT(CASE WHEN events_table.event_occured = 'offer received' THEN 1 END), 2) AS view_rate
FROM cafe_offers.offers
JOIN cafe_offers.events_table ON events_table.offer_id = offers.offer_id
JOIN cafe_offers.customers ON customers.customer_id = events_table.customer_id
WHERE customers.age < 118 -- ALL AGES
-- WHERE customers.age >= 65 AND customers.age < 118 -- 65+
-- WHERE customers.age >= 46 AND customers.age < 65 -- 46-64
-- WHERE customers.age >= 30 AND customers.age < 46 -- 30-45
-- WHERE customers.age >= 18 AND customers.age < 30 -- 18-29
GROUP BY offers.offer_id, web, email, mobile, social
ORDER BY offer_id;

-- Offer duration vs completion
SELECT offers.offer_id,
	offers.duration,
	COUNT(CASE WHEN events_table.event_occured = 'offer completed' THEN 1 END) AS offers_completed,
    COUNT(CASE WHEN events_table.event_occured = 'offer viewed' THEN 1 END) AS offers_viewed
FROM cafe_offers.offers
JOIN cafe_offers.events_table ON events_table.offer_id = offers.offer_id
GROUP BY offers.offer_id, offers.duration
ORDER BY duration ASC;
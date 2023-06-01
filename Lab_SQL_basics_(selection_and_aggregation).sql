use bank;

-- Query 1
-- Get the id values of the first 5 clients from district_id with a value equals to 1.

select * from client;

select client_id from client
where district_id = 1
order by client_id
limit 5;

-- Query 2
-- In the client table, get an id value of the last client where the district_id equals to 72.

select client_id from client
where district_id = 72
order by client_id desc
limit 1;

-- Query 3
-- Get the 3 lowest amounts in the loan table.

select amount from loan
order by amount asc
limit 3;

-- Query 4
-- What are the possible values for status, ordered alphabetically in ascending order in the loan table?

select distinct status from loan
order by status asc;

-- Query 5
-- What is the loan_id of the highest payment received in the loan table


SELECT loan_id
FROM loan
WHERE amount = (SELECT MAX(amount) FROM loan);
-- rever!!

-- Query 6
-- What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount

SELECT payments from loan
ORDER BY payments desc
LIMIT 5;

-- Query 7

select account_id, amount
from loan
where duration = 60
order by amount
limit 5;

-- Query 8

select distinct `k_symbol`
from `order`;

-- Query 9

select order_id
from `order`
where account_id = 34;

-- Query 10

select distinct account_id
from `order`
where order_id between 29540 and 29560;

-- Query 11

select distinct amount
from `order`
where account_to = '30067122';

-- Query 12

select trans_id, date, type, amount
from `trans`
where account_id = 793
order by date DESC
limit 10;

-- Query 13

select district_id, count(*) as client_count
from client
where district_id < 10
group by district_id
order by district_id asc;

-- Query 14

select type, count(*) as card_count
from card
group by type
order by card_count desc;

-- Query 15

select account_id, sum(amount) as total_loan_amount
from loan
group by account_id
order by total_loan_amount desc
limit 10;

-- Query 16

select date, count(*) as loan_count
from loan
where date < 930907
group by date
order by date desc;

-- Query 17!!!

select date, duration, count(*) as loan_count
from loan
where date >= 971201 and date < 980101
group by date, duration
order by date asc, duration asc;

-- Query 18

select account_id, type, sum(amount) as total_amount
from trans
where account_id = 396
  and (type = 'VYDAJ' or type = 'PRIJEM')
group by account_id, type
order by type asc;

-- Query 19

select account_id, 
  case
    when type = 'VYDAJ' then 'Outgoing'
    when type = 'PRIJEM' then 'Incoming'
  end as transaction_type,
  floor(sum(amount)) as total_amount
from trans
where account_id = 396
  and (type = 'VYDAJ' or type = 'PRIJEM')
group by account_id, type
order by transaction_type asc;

-- Query 20 !!!

SELECT
  SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE 0 END) AS incoming_amount,
  SUM(CASE WHEN type = 'VYDAJ' THEN amount ELSE 0 END) AS outgoing_amount,
  SUM(CASE WHEN type = 'PRIJEM' THEN amount ELSE -amount END) AS difference
FROM trans
WHERE account_id = 396
  AND (type = 'VYDAJ' OR type = 'PRIJEM');
  
  
-- Query 21 

select account_id, difference
from (
  select account_id, sum(case when type = 'PRIJEM' then amount else -amount end) as difference,
         rank() over (order by sum(case when type = 'PRIJEM' then amount else -amount end) desc) as rank_value
  from trans
  where (type = 'VYDAJ' or type = 'PRIJEM')
  group by account_id
) as ranked_accounts
where rank_value <= 10;

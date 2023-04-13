select * from pizza_recipes
select * from pizza_toppings
select * from pizza_names

--Data Cleaning Steps
Creating temporary tables for all Pizza related tables with Data cleaning 

--#pizza_toppings
select topping_id,cast(topping_name as varchar(max)) topping_name into #pizza_toppings from pizza_toppings

select * from pizza_toppings
select * from #pizza_toppings

--#pizza_names
select 
	pizza_id, 
	cast(pizza_name as varchar(max)) pizza_name
into #pizza_names
from pizza_names;

select * from pizza_names
select * from #pizza_names

--#pizza_recipes
select 
	  pizza_id, 
	   trim(value)toppings
into #pizza_recipes
-- change data type to varchar for split row
from (
	  select 
	  	pizza_id, 
	  	cast(toppings as varchar(max)) toppings
	  from pizza_recipes) a 
 CROSS APPLY STRING_SPLIT(toppings, ',')
order by pizza_id;

--#customer_orders
select * from #customer_orders
select order_id,customer_id,pizza_id,
case when exclusions='null' then ' ' else exclusions end as exclusions,
case when extras='null' or extras IS NULL then ' ' else extras end as extras,
order_time
into customer_orders#  from customer_orders

--Each order contain 1 or many pizzas so it is difficult to select each one seperately for further analysis.So adding one seperate column in customer

ALTER TABLE #customer_orders
ADD record_id INT IDENTITY(1,1);

--#extras
select record_id,trim(value) as extras into #_extras_listup1 from
(
select order_id,record_id,customer_id,pizza_id,
case when exclusions='null' then ' ' else exclusions end as exclusions,
case when extras='null' or extras IS NULL then ' ' else extras end as extras,
order_time from #customer_orders) e
CROSS APPLY STRING_SPLIT(extras, ',');

--exclusions
select record_id,trim(value) as exclusions into #exclusion_list from
(
select order_id,record_id,customer_id,pizza_id,
case when exclusions='null' then ' ' else exclusions end as exclusions,
case when extras='null' or extras IS NULL then ' ' else extras end as extras,
order_time from #customer_orders) e
CROSS APPLY STRING_SPLIT(exclusions, ',');

--------------------------------------------------


Q1. What are the standard ingredients for each pizza?

select STRING_AGG(topping_name, ',') toppings,pizza_name from #pizza_toppings pt
join #pizza_recipes pr on pt.topping_id=pr.toppings
join #pizza_names pn on pn.pizza_id=pr.pizza_id
group by pizza_name



Q2. What was the most commonly added extra?

Query:

select count(*) as extra_count,topping_name from #pizza_toppings pt join #_extras_listup1 el
on pt.topping_id=el.extras
group by topping_name


Q3. What was the most common exclusion?

select count(*) as extra_count,topping_name from #pizza_toppings pt join #exclusion_list el
on pt.topping_id=el.exclusions
group by topping_name
order by extra_count desc


Q4.Generate an order item for each record in the customers_orders table in the format of one of the following


WITH cteExtras AS (
  SELECT 
    ext.record_id,
    'Extra ' + STRING_AGG(t.topping_name,',') AS record_options
  FROM #_extras_listup1 ext
  JOIN #pizza_toppings t
    ON ext.extras = t.topping_id
  GROUP BY ext.record_id
), 
cteExclusions AS (
  SELECT 
    exc.record_id,
    'Exclusion ' + STRING_AGG(t.topping_name, ', ') AS record_options
  FROM #exclusion_list exc
  JOIN #pizza_toppings t
    ON exc.exclusions = t.topping_id
  GROUP BY exc.record_id
), 
cteUnion AS (
  SELECT * FROM cteExtras
  UNION
  SELECT * FROM cteExclusions
)

SELECT 
  c.record_id,
  c.customer_id,
  c.pizza_id,
  c.order_time,
  CONCAT_WS(' - ', p.pizza_name, STRING_AGG(u.record_options, ' - ')) AS pizza_info
FROM #customer_orders c
LEFT JOIN cteUnion u
  ON c.record_id = u.record_id
JOIN #pizza_names p
  ON c.pizza_id = p.pizza_id
GROUP BY
  c.record_id, 
  c.order_id,
  c.customer_id,
  c.pizza_id,
  c.order_time,
  p.pizza_name
ORDER BY record_id;



Q5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant 
ingredients to join #pizza_recipes with pizza_topings to get topping_name

--Data cleaning to combine #pizza_recipes and #pizza_toppings
SELECT		
   p.pizza_id,
   TRIM(t.value) AS toppings,
   pt.topping_name
 INTO #pizza_recipes_toppings
 FROM #pizza_recipes as p
     CROSS APPLY string_split(p.toppings, ',') as t
     JOIN pizza_toppings as pt
     ON TRIM(t.value) = pt.topping_id 

	 select * from #pizza_recipes_toppings

--Query to get output 

WITH ingredients_cte AS
(
	SELECT
	c.record_id, p.pizza_name,
		CASE
		WHEN t.toppings
		IN (select extras from #_extras_listup1 e where c.record_id = e.record_id)
		THEN '2x' + cast(t.topping_name as varchar)
		ELSE cast(t.topping_name as varchar)
	END as toppingu
	FROM 
		#customer_orders c
		JOIN #pizza_names p
			ON c.pizza_id = p.pizza_id
		JOIN #pizza_recipes_toppings t 
			ON c.pizza_id = t.pizza_id
	WHERE t.toppings NOT IN (select exclusions from #exclusion_list e where c.record_id = e.record_id)
)
SELECT 
	record_id,
	CONCAT(pizza_name+':',STRING_AGG(toppingu , ', ')) as ingredients_list
FROM ingredients_cte
GROUP BY 
	record_id,
	pizza_name
ORDER BY 1;


Q6.What is the total quantity of each ingredient used in all ordered pizzas sorted by most frequent first?

WITH ingredients_cte AS
(
SELECT 
	c.record_id,
	t.topping_name,
	CASE
		-- if extra ingredient add 2
		WHEN t.toppings 
		IN (select extras from #_extras_listup1 e where e.record_id = c.record_id) 
		THEN 2
		-- if excluded ingredient add 0
		WHEN t.toppings
		IN (select exclusions from #exclusion_list e where e.record_id = c.record_id) 
		THEN 0
		-- normal ingredient add 1
		ELSE 1 
	END as times_used
	FROM   
		#customer_orders AS c
		JOIN #pizza_recipes_toppings AS t
		ON c.pizza_id = t.pizza_id
) 
SELECT 
    cast(topping_name as varchar)as topping_name,SUM(times_used) AS times_used 
FROM ingredients_cte
GROUP BY cast(topping_name as varchar)
ORDER BY 2 DESC;

--------------------------------------------------------------------------------------------








	 

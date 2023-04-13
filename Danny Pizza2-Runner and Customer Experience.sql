select * from pizza_names
select * from pizza_recipes
select * from pizza_toppings
select * from runner_orders
select * from runners
select * from customer_orders
select * from runner_orders


--Data Cleaning Steps

--1.customer_orders table 
select order_id,customer_id,pizza_id,
case when exclusions='null' then ' ' else exclusions end as exclusions,
case when extras='null' or extras IS NULL then ' ' else extras end as extras,
order_time
into customer_orders#  from customer_orders

--2.runner_orders table
SELECT order_id, runner_id,
  CASE 
    WHEN pickup_time LIKE 'null' THEN ''
    ELSE pickup_time
    END AS pickup_time,
  CASE 
    WHEN distance LIKE 'null' THEN ''
    WHEN distance LIKE '%km' THEN TRIM( 'km' FROM distance)
    ELSE distance 
    END AS distance,
  CASE 
    WHEN duration LIKE 'null' THEN ''
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
    WHEN duration LIKE '%minutes' THEN TRIM( 'minutes' FROM duration)
    ELSE duration
    END AS duration,
  CASE 
    WHEN cancellation IS NULL OR cancellation LIKE 'null' THEN ''
    ELSE cancellation
    END AS cancellation
INTO #runner_orders-- #this will be our table of reference throghout the analysis
FROM runner_orders;



1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select * from runners
select datepart(week,registration_date) as weekly,count(runner_id) as number_of_runners  from runners
group by datepart(week,registration_date)

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT r.runner_id, AVG(DATEDIFF(MINUTE,c.order_time,try_cast(r.pickup_time as datetime))) AS avg_minutes
FROM runner_orders r
JOIN customer_orders c
ON r.order_id = c.order_id
WHERE r.pickup_time != 'null'
GROUP BY runner_id

3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

with cte as
(
SELECT r.runner_id,c.order_time,r.pickup_time,count(c.order_id) as pizza_order, DATEDIFF(MINUTE,c.order_time,cast(r.pickup_time as datetime)) AS prep_minutes
FROM runner_orders r
JOIN customer_orders c
ON r.order_id = c.order_id
WHERE r.distance != 'null'
GROUP BY r.runner_id,c.order_time,r.pickup_time
)
select pizza_order,AVG(prep_minutes) as avg_prep_mins from cte  group by pizza_order

4.What was the average distance travelled for each customer?

select customer_id,round(avg(cast(distance as float)),2) as avg_distance_travelled from #runner_orders r
join customer_orders c on r.order_id=c.order_id
where r.distance!=''
group by customer_id

5.What was the difference between the longest and shortest delivery times for all orders?

SELECT cast(MAX(duration) as float) - cast(MIN(duration) as float) as delivery_difference
FROM runner_orders#
where duration != ''

6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

select order_id,runner_id,r.distance,(r.duration/60) as duration_hr,round((cast(r.distance as float)/cast(r.duration as float) *60),2) as avg_speed from runner_orders# r
where r.distance!=''
group by order_id,r.distance,r.duration,runner_id

speed=distance travelled/time

7.What is the successful delivery percentage for each runner?

SELECT runner_id, 100*SUM(CASE WHEN duration != 0 THEN 1 ELSE 0 END)/ COUNT(order_id) AS successful_percentage
FROM #runner_orders
GROUP BY runner_id

 

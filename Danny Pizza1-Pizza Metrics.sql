A. Pizza Metrics

1. How many pizzas were ordered?

select count(*) as Number_pizza_ordered from customer_orders  

2. How many unique customer orders were made?

To find unique customers

  select count(DISTINCT CUSTOMER_ID) as Number_pizza_ordered_unique_customers from customer_orders  

To find count how many orders each unique customer made. This query includes all orders, successful ones and cancelled ones.unique customers

  select customer_id,count(DISTINCT ORDER_ID) as Number_pizza_ordered_unique_customers from customer_orders 
  group by  customer_id

3. How many successful orders were delivered by each runner?

  select runner_id,count(order_id) as successfull_orders from runner_orders
  where pickup_time<> 'NULL'
  and distance <>'NULL'
  and duration <>'NULL'
  group by runner_id

4. How many of each type of pizza was delivered?

SELECT
  pizza_name,
  COUNT(pizza_name) AS number_of_pizzas_delivered
FROM
  customer_orders AS c
  JOIN pizza_names AS n ON c.pizza_id = n.pizza_id
  JOIN runner_orders AS r ON c.order_id = r.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
GROUP BY
  pizza_name
ORDER BY
  pizza_name

5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT customer_id,
  pizza_name,
  COUNT(pizza_name) AS number_of_pizzas_delivered
FROM
  customer_orders AS c
  JOIN pizza_names AS n ON c.pizza_id = n.pizza_id
  JOIN runner_orders AS r ON c.order_id = r.order_id
WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
GROUP BY
  pizza_name,customer_id
ORDER BY
  customer_id

6. What was the maximum number of pizzas delivered in a single order?

 with orders as
  (
  select co.order_id,co.customer_id,count(co.order_id) as items_order,rank() OVER (
      ORDER BY
        COUNT(co.order_id) DESC
    ) AS rank
 from customer_orders co
  join runner_orders ro on co.order_id=ro.order_id
  WHERE
  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
  group by co.order_id,co.customer_id
  )
  select * from orders where rank=1

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

     SELECT customer_id,
       SUM(CASE
               WHEN exclusions <> ' ' and exclusions <> 'null'
                     OR extras <>' ' and  extras <> 'null' THEN 1
               ELSE 0
           END) AS at_least_1_change,
       SUM(CASE
               WHEN exclusions =' ' or exclusions = 'null'
                     AND extras = ' ' or extras = 'null' THEN 1
               ELSE 0
           END) AS no_change_in_pizza
FROM customer_orders
JOIN runner_orders on customer_orders.order_id=runner_orders.order_id
WHERE distance<>'null'
GROUP BY customer_id
ORDER BY customer_id;

8. How many pizzas were delivered that had both exclusions and extras?

 SELECT customer_id,
       sum(CASE
               WHEN exclusions <> ' ' and exclusions <> 'null'
                     AND extras <>' ' and  extras <> 'null' THEN 1
               ELSE 0
           END) AS both_change_in_pizza
       FROM customer_orders
JOIN runner_orders on customer_orders.order_id=runner_orders.order_id
WHERE distance >= '1' and  pickup_time != 'null'
  AND distance != 'null'
  AND duration != 'null'
GROUP BY customer_id
ORDER BY customer_id;

9. What was the total volume of pizzas ordered for each hour of the day?

---DATEPART (date_part, date) and DATENAME (date_part, date) both return parts of the date. 
---DATEPART returns them as integer values, while DATENAME returns them as strings.

SELECT DATEPART(HOUR, [order_time]) AS hour_of_day, 
 COUNT(order_id) AS pizza_count
FROM customer_orders
GROUP BY DATEPART(HOUR, [order_time]);

10. What was the volume of orders for each day of the week?

SELECT FORMAT(DATEADD(DAY, 2, order_time),'dddd') AS day_of_week , 
-- add 2 to adjust 1st day of the week as Monday
 COUNT(order_id) AS total_pizzas_ordered
FROM customer_orders
GROUP BY FORMAT(DATEADD(DAY, 2, order_time),'dddd');

---DATEADD(date_part, interval, date) takes 3 arguments and returns a date 
---that is interval (date_parts) number of given units (date_part) distant from the given date (date).

Case-Study-2-Danny-Ma-Pizza-Runner

![image](https://user-images.githubusercontent.com/126285330/226099275-839259d7-500b-43df-9e20-61fa034e1b0e.png)

Business Case

Danny was sold on the idea “80s Retro Styling and Pizza Is The Future!”, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/126285330/226099014-eab9a0aa-15d5-4ef0-8689-18a5c244d6bc.png)


Case Study Questions

Each of the following case study questions can be answered using a single SQL statement.

A. Pizza Metrics
1.How many pizzas were ordered?

2.How many unique customer orders were made?

3.How many successful orders were delivered by each runner?

4.How many of each type of pizza was delivered?

5.How many Vegetarian and Meatlovers were ordered by each customer?

6.What was the maximum number of pizzas delivered in a single order?

7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

8.How many pizzas were delivered that had both exclusions and extras?

9.What was the total volume of pizzas ordered for each hour of the day?

10.What was the volume of orders for each day of the week?


B. Runner and Customer Experience
How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Is there any relationship between the number of pizzas and how long the order takes to prepare?
What was the average distance travelled for each customer?
What was the difference between the longest and shortest delivery times for all orders?
What was the average speed for each runner for each delivery and do you notice any trend for these values?
What is the successful delivery percentage for each runner?

C. Ingredient Optimisation
What are the standard ingredients for each pizza?
What was the most commonly added extra?
What was the most common exclusion?
Generate an order item for each record in the customers_orders table in the format of one of the following: Meat Lovers Meat Lovers - Exclude Beef Meat Lovers - Extra Bacon Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


D. Pricing and Ratings
If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries? customer_id order_id runner_id rating order_time pickup_time Time between order and pickup Delivery duration Average speed Total number of pizzas
If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

Solution
GitHub
A. Danny Pizza1-Pizza Metrics
B. Danny Pizza2-Runner and Customer Experience
C. Danny Pizza3-Ingredient Optimisation
D. Danny Pizza4-Pricing and Ratings



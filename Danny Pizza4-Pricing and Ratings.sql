-----D. Pricing and Ratings

-----1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so
---far if there are no delivery fees?

select c.pizza_id,pn.pizza_name,sum(case when c.pizza_id=1 then 12 when c.pizza_id=2 then 10 end )money from  #customer_orders c
left join #runner_orders r on c.order_id=r.order_id
join #pizza_names pn on pn.pizza_id=c.pizza_id
where r.distance!=' '
group by c.pizza_id,pn.pizza_name



----2.What if there was an additional $1 charge for any pizza extras?
------Add cheese is $1 extra

select sum(money) as Profit_with_extras from
(
select c.pizza_id,sum(case when c.pizza_id=1 then 12 when c.pizza_id=2 then 10 end )money from  #customer_orders c
left join #runner_orders r on c.order_id=r.order_id
join #pizza_names pn on pn.pizza_id=c.pizza_id
where r.distance!=' '
group by c.pizza_id
union all
select pizza_id,sum(case when extras!=' ' then 1 else 0 end)  as money from #_extras_listup2
group by pizza_id
)a


----3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
----how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings 
----for each successful customer order between 1 to 5.

create table #ratings 
( order_id int ,ratings int,
review varchar(max));


insert into #ratings values
(1, 1, 'Really bad service'),
  (2, 2, null),
  (3, 4, 'Good service'),
  (4, 2, 'Pizza arrived cold and took long'),
  (5, 3, null),
  (7, 3, null),
  (8, 5, 'It was great, good service and fast'),
  (10, 4, 'Not bad');



---4.Using your newly generated table - can you join all of the information together to form a table which has the following information 
----for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas

select 
	c.customer_id, c.order_id, r.runner_id,
	ro.ratings, c.order_time, r.pickup_time,
	DATEPART(MINUTE, r.pickup_time - c.order_time) time_between_order_and_pickup,
	r.duration delivery_duration,
	round(cast(r.distance as float)/cast (r.duration as float) * 60, 2) average_speed,
	count(*) Total_number_of_pizzas
into #generated_table6
from #ratings ro
left join #customer_orders c on c.order_id = ro.order_id
left join #runner_orders r on ro.order_id = r.order_id
where r.distance != ' '
group by c.customer_id, c.order_id, r.runner_id, ro.ratings, c.order_time, r.pickup_time, r.distance, r.duration;




---5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
--- how much money does Pizza Runner have left over after these deliveries?

select 
	sum(money) money_left
from
	(
		select 
			sum(case when pizza_id = 1 then 12
					when pizza_id = 2 then 10 end) money
		from #customer_orders c
		left join #runner_orders r on r.order_id = c.order_id
		where distance != ' '
	UNION ALL
		select 
			sum(cast(distance as float)) * -0.3 money
		from #runner_orders 
		where distance != ' '
	)a;
-- Ques : Calculate the percentage contribution of each pizza type to total revenue.


SELECT 
    pizza_types.category,
   round( (SUM(pizzas.price * orders_details.quantity) / (SELECT 
            ROUND(SUM(pizzas.price * orders_details.quantity),
                        2)
        FROM
            pizzas
                JOIN
            orders_details ON pizzas.pizza_id = orders_details.pizza_id)) * 100,2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- ANS:
-- Classic	26.91
-- Supreme	25.46
-- Chicken	23.96
-- Veggie	23.68

-- Ques : Analyze the cumulative revenue generated over time.

Select order_date ,round(SUM(revenue) over (order by order_date),2) as cumulative_revenue
FROM            
(SELECT orders.order_date ,
round(SUM(orders_details.quantity * pizzas.price),2) AS revenue
FROM orders_details JOIN pizzas 
on orders_details.pizza_id = pizzas.pizza_id 
JOIN orders
ON orders.order_id = orders_details.order_id
group by orders.order_date) as sales;

-- Ans:
-- 2015-01-01	2713.85
-- 2015-01-02	5445.75
-- 2015-01-03	8108.15
-- 2015-01-04	9863.6
-- 2015-01-05	11929.55
-- 2015-01-06	14358.5
-- 2015-01-07	16560.7
-- 2015-01-08	19399.05

-- Ques - Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT name, revenue  from
(Select category,name,revenue,
rank() over (partition by category order by revenue desc) as rn
FROM
(SELECT pizza_types.category, pizza_types.name,
sum((orders_details.quantity)*pizzas.price) as revenue
from pizza_types Join pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
Join orders_details
On orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn<=3 ;

-- ANS :
-- The Thai Chicken Pizza	43434.25
-- The Barbecue Chicken Pizza	42768
-- The California Chicken Pizza	41409.5
-- The Classic Deluxe Pizza	38180.5
-- The Hawaiian Pizza	32273.25
-- The Pepperoni Pizza	30161.75
-- The Spicy Italian Pizza	34831.25
-- The Italian Supreme Pizza	33476.75
-- The Sicilian Pizza	30940.5
-- The Four Cheese Pizza	32265.70000000065
-- The Mexicana Pizza	26780.75
-- The Five Cheese Pizza	26066.5

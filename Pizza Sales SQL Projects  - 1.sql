-- Database creation 
CREATE database pizzahut;

-- Exploring tables
SELECT * FROM pizzahut.pizzas;
SELECT * FROM pizzahut.pizza_types;
SELECT * FROM pizzahut.orders;
SELECT * FROM pizzahut.orders_details;

-- Creating a table to import big data
create table orders (
order_id  int not NULL,
order_date date not NULL,
order_time time not NULL,
primary key(order_id)
);

create table orders_details (
order_details_id int not NULL,
order_id  int not NULL,
pizza_id text not NULL,
quantity int not NULL,
primary key(order_details_id)
);

-- Ques - Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders_placed
FROM
    orders;

-- Answer -> 21350

-- Ques - Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) total_rev_generated
FROM
    orders_details
        JOIN
    pizzas ON pizzas.pizza_id = orders_details.pizza_id;

-- Answer -> 817860.05

-- Ques - Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Answer ->
-- The Greek Pizza	35.95

-- Ques : Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS counts
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY counts DESC; 

-- Answer ->
-- L	18526
-- M	15385
-- S	14137
-- XL	544
-- XXL	28

-- Ques : List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5
; 

-- Answer ->
-- The Classic Deluxe Pizza	2453
-- The Barbecue Chicken Pizza	2432
-- The Hawaiian Pizza	2422
-- The Pepperoni Pizza	2418
-- The Thai Chicken Pizza	2371




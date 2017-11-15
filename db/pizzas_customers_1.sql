SELECT customers.*, pizzas.*
FROM customers, pizzas, orders
WHERE orders.customer_id = customers.id
AND orders.pizza_id = pizzas.id

---- refactor pizza_shop.sql
---Create a customers table with an id and a name
----The pizza_orders no longer needs to know the details of the customer,
---so remove the customers name details and add a reference to the customers table

---when you drop, you drop the one with the reference first
---when you create you create the one with no reference first

DROP TABLE pizza_orders;
DROP TABLE customers;

CREATE TABLE customers(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE pizza_orders(
  id SERIAL8 PRIMARY KEY,
  topping VARCHAR(255),
  quantity  INT2,
  customer_id INT4 REFERENCES customers(id)
);

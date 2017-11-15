require('pg')
require_relative('../db/sql_runner.rb')
require_relative('customer.rb')

class PizzaOrder

 attr_accessor :customer_id, :quantity, :topping
 attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']## it will ignore the line until we map the objects
    @quantity = options['quantity'].to_i
    @topping = options['topping']
    @customer_id = options['customer_id'].to_i
  end

  def save
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})##DRY: don't repeat your self
    sql = "INSERT INTO pizza_orders(
    quantity,
    topping,
    customer_id
    )
    VALUES(
    $1, $2, $3
    )
    RETURNING * "
    values = [@quantity, @topping, @customer_id ]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close
  end

  def self.all
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    sql = "SELECT * FROM pizza_orders"
    values = []
    db.prepare("all", sql)
    orders = db.exec_prepared("all", values)
    db.close
    return orders.map {|order| PizzaOrder.new(order)}
  end

  def self.delete_all
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    sql = "DELETE FROM pizza_orders"
    db.prepare("delete_all",sql)
    db.exec_prepared("delete_all")
    db.close
  end

  def delete(id)
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    sql = "DELETE FROM pizza_orders WHERE id = $1"
    values = [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete")
    db.close
  end

  def update # we call that in the concole
    db = PG.connect( {dbname: 'pizza_orders', host: 'localhost'} )
    #sql = "UPDATE pizza_orders SET (first_name, last_name, quantity, topping) = ("Sian", "RD", "Peperoni", 3)
    #WHERE id = 3"
    sql = "UPDATE pizza_orders SET (first_name, last_name, topping, quantity) = ($1, $2, $3, $4)
    WHERE id = $5"
    values = [@first_name, @last_name, @topping, @quantity, @id]
    db.prepare("myupdate", sql)
    deleted_order = db.exec_prepared("myupdate", values)
    db.close
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    # customers = SqlRunner.run( sql, values)#returns an array of hashes
    customer = SqlRunner.run(sql, values)
    return customer.map {|customer_hash| Customer.new(customer_hash)}
    # return Customer.new(customer[0])
  end

end

# customers_hash = results_array[0]
#   customer = Customer.new(customers_hash)

# Write the .customer method for our PizzaOrder class and the .pizza_orders method for our Customer class.
#
# .customer method:
#
# Our Order objects know their own @customer_id
# We can use this in our SQL statement (use SqlRunner) to get back the customer data.
# Our .customer method should return a Customer object, an instance of the Customer class

# .pizza_orders method:
#
# Our Customer objects know their own @id
# We can use this in our SQL statement (use SqlRunner) to get back the data for all of their orders.
# Our .pizza_orders method should return an array of PizzaOrder objects, instances of the PizzaOrder class

# order1 # is a PizzaOrder object
# order1.customer # gets us a Customer object from our PizzaOrder object
# order1.customer.pizza_orders # gets us an array of PizzaOrder objects
# order1.customer.pizza_orders[0] # gets us just the first PizzaOrder object
# order1.customer.pizza_orders[0].customer # gets us the same Customer object back again

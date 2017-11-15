require('pg')
require_relative('../db/sql_runner.rb')
require_relative('pizza_order.rb')

class Customer

  attr_accessor :name
  attr_reader :id

  def initialize(options)
    @name = options["name"]
    @id = options['id'].to_i if options['id']
  end

  def self.all()
    sql = "SELECT * FROM customers"
    # values = [] I can set it as an empty default in sql_runner
    # customers = SqlRunner.run( sql, values)#returns an array of hashes
    customers = SqlRunner.run(sql)#when values are set as default
    return customers.map {|customer_hash| Customer.new(customer_hash)}
  end

  def save
    sql = "INSERT INTO customers (name) VALUES ($1) RETURNING * " # or RETURNING id"
    values = [@name]
    @id = SqlRunner.run(sql,values)[0]['id'].to_i
  end


  def self.delete_all
    sql = "DELETE FROM customers "
    values = []
    SqlRunner.run(sql, values)
  end

  def pizza_orders()#methods on the instance of the class
    sql = "SELECT* FROM pizza_orders WHERE customer_id = $1"
    values = [@id]
    pizza_order = SqlRunner.run(sql, values)
    return pizza_order.map {|pizza_order_hash| PizzaOrder.new(pizza_order_hash)}#returns pizza orders for one specific customer: an array
  end

end



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

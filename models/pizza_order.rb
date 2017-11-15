require('pg') # gem install pg (terminal)

class PizzaOrder

 attr_accessor :first_name, :last_name, :topping, :quantity
 attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']## it will ignore the line until we map the objects
    @first_name = options['first_name']
    @last_name = options['last_name']
    @topping = options['topping']
    @quantity = options['quantity'].to_i
  end

  def save
    #create a connection to the database
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    #save some sql into a variable (as a string)
    sql = "INSERT INTO pizza_orders(
    first_name,
    last_name,
    topping,
    quantity
  )
  VALUES(
    $1, $2, $3, $4
    )
    RETURNING * "#----returning * is to return the db output directly back to ruby
    #thats a ruby string with sql syntax
    values = [@first_name, @last_name, @topping, @quantity] #prepare statement (protection and faster speed)
    db.prepare("save", sql)
    # execute this sql
    @id = db.exec_prepared("save", values)[0]["id"].to_i #explain that bellow
    #returned array = db.exec_prepared("save", values)
    #hash_of_what_we_just_inserted_in_the_db = returned_array[0]
    #@id = hash_of_what_we_just_inserted_in_the_db["id"].to_i
    #db.exec_prepared return
    #[{id:'1', topping: ,}]#--we use [0] to pop out the id from the array
    #and the to_i to turn it into integer (postgres db only returns strings)
    #rundom example bellow:
    thing = db.exec_prepared("save", values)
    puts "The thing is #{thing[0]['id']}"
    #close our database connetion
    db.close
  end

  def self.all
    #create a connection to the database
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    #save some sql into a variable (as a string)
    sql = "SELECT * FROM pizza_orders" # if I was to return one value: "SELECT * FROM pizza_orders WHERE name = $1"
    values = []
    db.prepare("all", sql)#'all' can be anything. its a label for db.prepare and db.exec to communicate
    # execute this sql
    orders = db.exec_prepared("all", values)
    #close our database connetion
    db.close
    #return all the orders
    return orders.map {|order| PizzaOrder.new(order)} # turn the array of raw data(table) into array of hash objects: []---->[{},{},{},{}]
  end

  def self.delete_all
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    sql = "DELETE FROM pizza_orders"
    db.prepare("delete_all",sql)
    db.exec_prepared("delete_all")
    db.close
  end

  def delete
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    sql = "DELETE FROM pizza_orders WHERE id = #{@id}"
    db.prepare("delete", sql)
    db.exec_prepared("delete")
    db.close
  end

  def update # we call that in the concole
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    #sql = "UPDATE pizza_orders SET (first_name, last_name, quantity, topping) = ("Sian", "RD", "Peperoni", 3)
    #WHERE id = 3"
    sql = "UPDATE pizza_orders SET (first_name, last_name, topping, quantity) = ($1, $2, $3, $4)
    WHERE id = $5"
    values = [@first_name, @last_name, @topping, @quantity, @id]
    db.prepare("myupdate", sql)
    deleted_order = db.exec_prepared("myupdate", values)
    db.close
  end


end

require('pg')

class Customer

  attr_accessor :name
  attr_reader :id

  def initialize(options)
    @name = options["name"]
    @id = options['id'].to_i if options['id']
  end

  def save
    db = PG.connect( { dbname:'pizza_orders', host:'localhost' } )
    sql = "INSERT INTO customers (name) VALUES ($1) RETURNING * " # or RETURNING id"
    values = [@name]
    db.prepare('save', sql)
    @id = db.exec_prepared('save',values)[0]['id'].to_i
    db.close
  end


  def self.delete_all
    db = PG.connect( { dbname:'pizza_orders', host:'localhost' } )
    sql = "DELETE FROM customers "
    values = []
    db.prepare('delete_all', sql)
    db.exec_prepared('delete_all', values)
    db.close
  end

end

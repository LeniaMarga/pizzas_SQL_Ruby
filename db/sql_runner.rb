require('pg')

class SqlRunner

  def self.run(sql, values = [])
    begin
      db = PG.connect( { dbname: 'pizza_orders', host: 'localhost'} )
      db.prepare('query', sql)
      result = db.exec_prepared('query', values)
    ensure
      db.close() if db != nil # this will run even if the first part doesn't run
    end
    return result
  end

end

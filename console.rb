require('pry-byebug')
require_relative('models/pizza_order')
require_relative('models/customer')

Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Zsolt' })
customer1.save()

binding.pry
nil



#
#
#
# require('pry')
# require('pp')
# require_relative('models/pizza_order')
#
#  order1 = PizzaOrder.new(
#    { 'first_name'=> 'Luke',  # columns in the table...
#    'last_name'=> 'Skywalker',
#    'quantity'=> '1',
#    'topping'=> 'Napoli'}
#  )
#
#  order2 = PizzaOrder.new(
#    { 'first_name'=> 'Darth',
#    'last_name'=> 'Vader',
#    'quantity'=> '1',
#    'topping'=> 'Quattro Formaggi' }
#  )
# # when we save, we don't have ids- only when we call them all.
# #so we have to set the id in each object in ruby
#  order1.save
#  order2.save
#
#  order2.first_name = 'Anakin'
#  order2.topping = 'Mushroom'
#
#  order2.update
#  p order2
#
#  order1.delete
#
#  pp PizzaOrder.all()#pp instead of p to make array of objects look readable
#  p PizzaOrder.all.first()#p first object
#
#  binding.pry
#  nil

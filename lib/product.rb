# A single product
class Product
  attr_reader :name, :price
  attr_accessor :quantity

  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
  end
end

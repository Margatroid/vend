# A vending machine
class Machine
  def initialize(products, coins)
    @products = products
    @coins = coins
  end

  def print_products
    @products.each do |product|
      puts "Item: #{product.name} Qty: #{product.quantity} "\
           "Price: #{product.price}"
    end
  end

  def create_transaction
    Transaction.new
  end
end

# frozen_string_literal: true

# A vending machine
class Machine
  def initialize(products, coins)
    @products = products
    @coins = coins
  end

  def print_products
    @products.each_with_index do |product, index|
      puts "Code: #{index} Item: #{product.name} Qty: #{product.quantity} "\
           "Price: #{product.price}"
    end
  end

  def create_transaction
    Transaction.new(self)
  end
end

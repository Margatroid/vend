# frozen_string_literal: true

# A vending machine
class Machine
  def initialize(products, coins)
    @products = products
    @coins = coins
  end

  def formatted_products
    p = @products.map.with_index do |product, index|
      "Code: #{index + 1} Item: #{product.name} "\
      "Qty: #{product.quantity} Price: #{product.price}"
    end
    p.join("\n")
  end

  def create_transaction
    Transaction.new(self)
  end
end

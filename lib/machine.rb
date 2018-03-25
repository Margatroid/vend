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

  def product_by_code(code)
    @products[code - 1]
  end

  def product_in_stock?(code)
    @products[code - 1].quantity.positive?
  end

  def create_transaction
    Transaction.new(self)
  end

  def vend(product, coins)
    sum = Coin.sum(coins)
    raise InsufficientFunds if sum < product.price

    product.quantity -= 1
  end
end

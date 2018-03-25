# frozen_string_literal: true

# A vending machine
class Machine
  attr_reader :coins

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
    raise OutOfStock unless product.quantity.positive?
    raise InsufficientFunds if sum < product.price

    total_change_pool = coins.concat(@coins)
    product.quantity -= 1

    change = []
    if sum > product.price
      result = Coin.change(total_change_pool, sum - product.price)
      # The actual coins that represent the change to be given out.
      change = result[:change_coins]
      # Update machine's total coin pool after change has been given.
      @coins = result[:pool]
    end

    { change: change, success: true }
  end
end

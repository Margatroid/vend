# frozen_string_literal: true

# A single coin
class Coin
  attr_reader :denomination
  attr_accessor :quantity

  VALID_DENOMINATIONS = [1, 2, 5, 10, 20, 50, 100, 200].freeze

  def initialize(denomination, quantity)
    unless VALID_DENOMINATIONS.include?(denomination)
      raise ArgumentError,
            "Denomination must be #{VALID_DENOMINATIONS.join(', ')}"
    end

    @denomination = denomination
    @quantity = quantity
  end

  def self.sum(coins)
    coins.inject(0) do |sum, coin|
      sum + (coin.denomination * coin.quantity)
    end
  end

  def self.change(pool, change_amount)
    pool = VALID_DENOMINATIONS.reverse.map do |denomination|
      # Find coins in pool of this denomination.
      coins_of_denomination = pool.select do |coin|
        coin.denomination == denomination
      end

      # Combine coins of the same denomination.
      quantity = coins_of_denomination.inject(0) do |sum, coin|
        sum + coin.quantity
      end

      Coin.new(denomination, quantity)
    end

    change_to_give = []
    pool.each do |coin|
      while coin.denomination <= change_amount && coin.quantity.positive?
        coin.quantity -= 1
        change_amount -= coin.denomination
        change_to_give.push(Coin.new(coin.denomination, 1))
      end
    end

    change_to_give
  end
end

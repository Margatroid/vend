# frozen_string_literal: true

# A single coin
class Coin
  attr_reader :denomination, :quantity

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
end

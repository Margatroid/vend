# frozen_string_literal: true

# A single coin
class Coin
  attr_reader :denomination

  VALID_DENOMINATIONS = [1, 2, 5, 10, 20, 50, 100, 200].freeze

  def initialize(denomination)
    unless VALID_DENOMINATIONS.include?(denomination)
      raise ArgumentError, "Denomination must be #{VALID_DENOMINATIONS.join(', ')}"
    end

    @denomination = denomination
  end
end

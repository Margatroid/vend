# frozen_string_literal: true

# A single coin
class Coin
  attr_reader :denomination

  def initialize(denomination)
    @denomination = denomination
  end

  def self.valid_denominations
    [1, 2, 5, 10, 20, 50, 100, 200]
  end
end

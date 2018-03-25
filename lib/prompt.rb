# frozen_string_literal: true

require 'machine'
require 'product'
require 'coin'

# User interface
class Prompt
  def start
    products = [
      Product.new("Peanut M&M's", 120, 10),
      Product.new("Lindt", 180, 5),
      Product.new("Kitkat", 150, 20)
    ]

    coins = Coin::VALID_DENOMINATIONS.map do |denomination|
      Coin.new(denomination, 10)
    end

    machine = Machine.new(products, coins)

    puts <<~HEREDOC
      Welcome.
      1) Buy something.
      2) Check machine products and change.
      3) Reload the machine.
      4) Quit.
    HEREDOC
  end
end

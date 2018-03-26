# frozen_string_literal: true

require 'machine'
require 'product'
require 'coin'

$stdin = lambda do
  print '> '
  input = STDIN.gets.chomp.to_i
  puts "\n"
  input
end

$exit = -> { exit(true) }

# User interface
class Prompt
  def initialize(input = $stdin, exit_routine = $exit)
    # Allow stdin and exit to be stubbed so testing is unaffected.
    @input = input
    @exit = exit_routine
  end

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
    menu
  end

  def menu
    puts <<~HEREDOC
      Welcome.
      1) Buy something.
      2) Check machine's products and change.
      3) Reload the machine.
      4) Quit.
    HEREDOC

    case @input.call
    when 1
      buy
    when 2
    when 3
    when 4
      @exit.call
    end
  end
end

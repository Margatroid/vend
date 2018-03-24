# frozen_string_literal: true

require 'aasm'
require 'coin'

# A transaction state machine
class Transaction
  include AASM

  aasm whiny_transitions: false do
    state :idle, initial: true
    state :awaiting_payment
    state :finished

    event :select_product do
      transitions from: :idle, to: :awaiting_payment, guard: :product_selected?
    end

    event :insert_coin do
      transitions from: :awaiting_payment, to: :finished, guard: :paid?
    end
  end

  def initialize(machine)
    @machine = machine
    @balance = 0
    @errors = []
  end

  # Display prompt for current state
  def prompt
    case aasm.current_state
    when :idle
      <<~HEREDOC
        #{@errors.slice(0, @errors.length).join("\n")}
        This vending machine contains the following products:
        #{@machine.formatted_products}
        Please enter the code of the product that you want:
      HEREDOC
    when :awaiting_payment
      <<~HEREDOC
        #{@errors.slice(0, @errors.length).join("\n")}
        You have selected #{@selected_product.name} which costs #{@selected_product.price}.
        You have paid #{@balance + @selected_product.price} so far.
        Enter a coin denomination in pence (#{Coin::VALID_DENOMINATIONS.join(', ')}) to pay:
      HEREDOC
    when :finished
      <<~HEREDOC
        You have received a #{@selected_product.name}.
      HEREDOC
    end
  end

  def input(text)
    case aasm.current_state
    when :idle
      @product_code = text
      select_product
    when :awaiting_payment
      begin
        @coin = Coin.new(text)
      rescue ArgumentError
      end
      insert_coin
    end
  end

  def product_selected?
    @errors = ['You must enter a product code.']
    return false unless @product_code
    @selected_product = @machine.products[@product_code - 1]
    @errors = ["Product with code #{@product_code} does not exist"]
    return false unless @selected_product

    if @selected_product.quantity.positive?
      @balance -= @selected_product.price
      @errors = []
      true
    else
      @errors = ["Product #{@selected_product.name} has ran out"]
      false
    end
  end

  def paid?
    @errors = ['You must enter a valid coin denomination']
    return false unless @coin
    @balance += @coin.denomination

    if @balance.positive?
      # Return change
    elsif @balance.zero?
      # Exact change
      @machine.vend(@selected_product)
      true
    else
      # Not enough change given yet
      false
    end
  end
end

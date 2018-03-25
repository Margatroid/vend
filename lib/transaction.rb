# frozen_string_literal: true

require 'aasm'
require 'coin'

# A transaction state machine
class Transaction
  include AASM

  aasm whiny_transitions: false do
    state :idle, initial: true
    state :no_product_selected
    state :invalid_product_selected
    state :product_sold_out

    state :invalid_coin_inserted
    state :awaiting_payment
    state :paid_with_change
    state :paid_exact
    state :finished

    event :input_product_code do
      from_states = %i[idle no_product_selected invalid_product_selected product_sold_out]
      transitions from: from_states, to: :no_product_selected, unless: :product_selected?
      transitions from: from_states, to: :invalid_product_selected, unless: :product_valid?
      transitions from: from_states, to: :product_sold_out, unless: :product_in_stock?
      transitions from: from_states, to: :awaiting_payment, after: :select_product
    end

    event :insert_coin do
      from_states = %i[awaiting_payment invalid_coin_inserted]
      transitions from: from_states, to: :invalid_coin_inserted, unless: :coin_valid?
      transitions from: from_states, to: :awaiting_payment, unless: :paid?
      transitions from: from_states, to: :paid_with_change, if: :require_change?
      transitions from: from_states, to: :paid_exact
    end
  end

  def initialize(machine)
    @machine = machine
    @balance = 0
  end

  # Display prompt for current state
  def prompt
    case aasm.current_state
    when :idle
      <<~HEREDOC
        This vending machine contains the following products:
        #{@machine.formatted_products}
        Please enter the code of the product that you want:
      HEREDOC
    when :no_product_selected
      <<~HEREDOC
        You must enter a product code.
        Please enter the code of the product that you want:
      HEREDOC
    when :invalid_product_selected
      <<~HEREDOC
        Product with code #{@input} does not exist.
        Please enter the code of the product that you want:
      HEREDOC
    when :product_sold_out
      <<~HEREDOC
        Product has sold out.
        Please enter the code of the product that you want:
      HEREDOC
    when :invalid_coin_inserted
      <<~HEREDOC
        You must enter a valid coin denomination.
        Enter a coin denomination in pence (#{Coin::VALID_DENOMINATIONS.join(', ')}) to pay:
      HEREDOC
    when :awaiting_payment
      <<~HEREDOC
        You have selected #{@selected_product.name} which costs #{@selected_product.price}.
        You have paid #{@balance + @selected_product.price} so far.
        Enter a coin denomination in pence (#{Coin::VALID_DENOMINATIONS.join(', ')}) to pay:
      HEREDOC
    when :paid_with_change
      <<~HEREDOC
        You have received #{@balance} in change.
        An item has been vended.
      HEREDOC
    when :paid_exact
      <<~HEREDOC
        An item has been vended.
      HEREDOC
    when :finished
      <<~HEREDOC
        You have received a #{@selected_product.name}.
      HEREDOC
    end
  end

  def input(text = nil)
    @input = text
    case aasm.current_state
    when :idle, :no_product_selected, :invalid_product_selected, :product_sold_out
      input_product_code
    when :awaiting_payment
      insert_coin
    end
  end

  def product_selected?
    !@input.nil?
  end

  def product_valid?
    !@machine.product_by_code(@input).nil?
  end

  def product_in_stock?
    @machine.product_in_stock?(@input)
  end

  def select_product
    @selected_product = @machine.product_by_code(@input)
    @balance -= @selected_product.price
  end

  def coin_valid?
    begin
      @coin = Coin.new(@input, 1)
    rescue ArgumentError
      return false
    end
    true
  end

  def paid?
    update_balance
    @balance.positive? || @balance.zero?
  end

  def require_change?
    @balance.positive?
  end

  def update_balance
    @balance += @coin.denomination
  end
end

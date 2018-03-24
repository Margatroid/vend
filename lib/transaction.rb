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

    state :awaiting_payment
    state :finished

    event :input_product_code do
      from_states = %i[idle no_product_selected invalid_product_selected product_sold_out]
      transitions from: from_states, to: :no_product_selected, unless: :product_selected?
      transitions from: from_states, to: :invalid_product_selected, unless: :product_valid?
      transitions from: from_states, to: :product_sold_out, unless: :product_in_stock?
      transitions from: from_states, to: :awaiting_payment, after: :select_product
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
    when :no_product_selected
      <<~HEREDOC
        You must enter a product code.
        Please enter the code of the product that you want:
      HEREDOC
    when :invalid_product_selected
      <<~HEREDOC
        Product with code #{@product_code} does not exist.
        Please enter the code of the product that you want:
      HEREDOC
    when :product_sold_out
      <<~HEREDOC
        Product has sold out.
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

  def input(text = nil)
    case aasm.current_state
    when :idle, :no_product_selected, :invalid_product_selected, :product_sold_out
      @product_code = text
      input_product_code
    when :awaiting_payment
      begin
        @coin = Coin.new(text)
      rescue ArgumentError
      end
      insert_coin
    end
  end

  def product_selected?
    !@product_code.nil?
  end

  def product_valid?
    !@machine.products[@product_code - 1].nil?
  end

  def product_in_stock?
    @machine.products[@product_code - 1].quantity.positive?
  end

  def select_product
    @selected_product = @machine.products[@product_code - 1]
    @balance -= @selected_product.price
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

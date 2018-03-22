# frozen_string_literal: true

require 'aasm'

# A transaction state machine
class Transaction
  include AASM

  aasm whiny_transitions: false do
    state :idle, initial: true
    state :awaiting_payment

    event :select_product do
      transitions from: :idle, to: :awaiting_payment, guard: :product_selected?
    end
  end

  def initialize(machine)
    @machine = machine
    @errors = []
  end

  def prompt_product
    puts 'This vending machine contains the following products:'
    puts @machine.print_products
    puts 'Please enter the code of the product that you want:'
    true
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
        You have selected #{@selected_product.name}.
      HEREDOC
    end
  end

  def input(text)
    case aasm.current_state
    when :idle
      @product_code = text
      select_product
    end
  end

  def product_selected?
    @errors = ['You must enter a product code.']
    return false unless @product_code
    @selected_product = @machine.products[@product_code - 1]
    @errors = ["Product with code #{@product_code} does not exist"]
    return false unless @selected_product

    if @selected_product.quantity
      @errors = []
      true
    else
      false
    end
  end
end

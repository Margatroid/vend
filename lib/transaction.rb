# frozen_string_literal: true

require 'aasm'

# A transaction state machine
class Transaction
  include AASM

  aasm do
    state :idle, initial: true
    state :awaiting_payment

    event :select_product do
      transitions from: :idle, to: :awaiting_payment, guard: :prompt_product
    end
  end

  def initialize(machine)
    @machine = machine
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
        This vending machine contains the following products:
        #{@machine.formatted_products}
        Please enter the code of the product that you want:
      HEREDOC
    end
  end
end

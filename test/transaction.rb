# frozen_string_literal: true

require 'machine'
require 'transaction'
require 'minitest/autorun'

describe Transaction do
  before do
    products_to_load = [
      Product.new('chocolate one', 50, 2),
      Product.new('chocolate two', 51, 3)
    ]

    @machine = Machine.new(products_to_load, [])
    @transaction = @machine.create_transaction
  end

  describe 'happy path' do
    it 'will successfully complete a happy path' do
      expected = 'Please enter the code of the product that you want'
      assert(@transaction.prompt.include?(expected))
    end
  end
end

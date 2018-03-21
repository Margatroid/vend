# frozen_string_literal: true

require 'machine'
require 'transaction'
require 'minitest/autorun'

describe Machine do
  before do
    products_to_load = [
      Product.new('chocolate one', 50, 2),
      Product.new('chocolate two', 51, 3)
    ]

    @machine = Machine.new(products_to_load, [])
  end

  describe 'machine status' do
    it 'will print a list of products' do
      out = capture_io do
        @machine.print_products
      end

      assert(out[0].include?('Code: 0 Item: chocolate one Qty: 2 Price: 50'))
      assert(out[0].include?('Code: 1 Item: chocolate two Qty: 3 Price: 51'))
    end
  end

  describe 'transaction process' do
    it 'will start a transaction' do
      transaction = @machine.create_transaction
      assert_instance_of(Transaction, transaction)
      assert_equal(@machine, transaction.instance_variable_get(:@machine))
    end
  end
end

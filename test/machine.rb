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

      assert(out[0].include?('Item: chocolate one Qty: 2 Price: 50'))
      assert(out[0].include?('Item: chocolate two Qty: 3 Price: 51'))
    end
  end

  describe 'transaction process' do
    it 'will start a transaction' do
      assert_instance_of(Transaction, @machine.create_transaction)
    end
  end
end

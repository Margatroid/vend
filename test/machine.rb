require 'machine'
require 'minitest/autorun'

describe Machine do
  describe 'loading the machine' do
    it 'will print a list of products' do
      products_to_load = [
        Product.new('chocolate one', 50, 2),
        Product.new('chocolate two', 51, 3)
      ]

      machine = Machine.new(products_to_load, [])
      out = capture_io do
        machine.print_products
      end

      assert(out[0].include?('Item: chocolate one Qty: 2 Price: 50'))
      assert(out[0].include?('Item: chocolate two Qty: 3 Price: 51'))
    end
  end
end

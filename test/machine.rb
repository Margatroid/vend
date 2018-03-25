# frozen_string_literal: true

require 'machine'
require 'product'
require 'transaction'
require 'minitest/autorun'

describe Machine do
  before do
    products_to_load = [
      Product.new('chocolate one', 50, 2),
      Product.new('chocolate two', 51, 3),
      Product.new('chocolate three', 51, 0)
    ]

    @machine = Machine.new(products_to_load, [])
  end

  describe 'machine status' do
    it 'will print a list of products' do
      products = @machine.formatted_products
      assert(products.include?('Code: 1 Item: chocolate one Qty: 2 Price: 50'))
      assert(products.include?('Code: 2 Item: chocolate two Qty: 3 Price: 51'))
    end
  end

  describe 'transaction process' do
    it 'will start a transaction' do
      transaction = @machine.create_transaction
      assert_instance_of(Transaction, transaction)
      assert_equal(@machine, transaction.instance_variable_get(:@machine))
    end
  end

  describe 'stock checking' do
    it 'will be able to tell if a product exists' do
      assert(@machine.product_by_code(1))
      assert_instance_of(Product, @machine.product_by_code(2))
      refute(@machine.product_by_code(99))
    end

    it 'will give you whether it is in stock or not' do
      assert(@machine.product_in_stock?(1))
      refute(@machine.product_in_stock?(3))
    end
  end

  describe 'vending process' do
    before do
      products_to_load = [Product.new('a', 50, 1)]
      coins_to_load = [Coin.new(50, 5), Coin.new(2, 5000)]
      @machine = Machine.new(products_to_load, coins_to_load)
    end

    it 'will vend the product from itself' do
      product_code = 1
      assert(@machine.product_in_stock?(product_code))
      product = @machine.product_by_code(product_code)
      @machine.vend(product, [Coin.new(50, 1)])
      refute(@machine.product_in_stock?(1))
    end

    it 'will refuse to vend when insufficient funds have been inserted' do
    end

    it 'will give change' do
    end

    it 'will refuse to vend when product is out of stock' do
    end
  end
end

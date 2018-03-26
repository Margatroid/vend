# frozen_string_literal: true

require 'machine'
require 'transaction'
require 'minitest/autorun'

describe Transaction do
  before(:each) do
    products_to_load = [
      Product.new('chocolate one', 50, 2),
      Product.new('chocolate two', 51, 3),
      Product.new('chocolate three', 52, 0)
    ]

    @machine = Machine.new(products_to_load, [Coin.new(50, 1)])
    @transaction = @machine.create_transaction
  end

  describe 'happy path' do
    it 'will successfully complete a happy path' do
      expected = 'Please enter the code of the product that you want'
      assert(@transaction.prompt.include?(expected))

      @transaction.input(2)
      expected = 'You have selected chocolate two'
      assert(@transaction.prompt.include?(expected))
      not_expected = 'does not exist'
      refute(@transaction.prompt.include?(not_expected))

      @transaction.input(50)
      expected = 'You have paid 50 so far'
      assert(@transaction.prompt.include?(expected))

      @transaction.input(1)
      expected = 'An item has been vended'
      assert(@transaction.prompt.include?(expected))
    end
  end

  describe 'product selection validation' do
    it 'will not continue without a product code' do
      @transaction.input
      expected = 'You must enter a product code'
      assert(@transaction.prompt.include?(expected))
    end

    it 'will not accept invalid product codes' do
      @transaction.input(999)
      expected = 'Product with code 999 does not exist'
      assert(@transaction.prompt.include?(expected))
    end

    it 'will tell you if a product has ran out' do
      @transaction.input(3)
      expected = 'Product has sold out'
      assert(@transaction.prompt.include?(expected))
    end
  end

  describe 'coin input validation' do
    it 'will not accept an invalid coin denomination' do
      # Select first product
      @transaction.input(1)
      # Insert an invalid coin (6p)
      @transaction.input(6)
      expected = 'You must enter a valid coin denomination'
      assert(@transaction.prompt.include?(expected))
      assert_empty(@transaction.instance_variable_get(:@coins))

      @transaction.input(1)
      expected = 'You have paid 1 so far'
      assert(@transaction.prompt.include?(expected))
    end
  end

  describe 'giving change' do
    it 'will give change' do
      # Select first product
      @transaction.input(1)
      # Insert 1 pound coin
      @transaction.input(100)
      expected = 'You have received 50 in change'
      assert(@transaction.prompt.include?(expected))
      assert_equal(1, @transaction.instance_variable_get(:@change).length)
    end
  end
end

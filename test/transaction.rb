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

    @machine = Machine.new(products_to_load, [])
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
    end
  end

  describe 'validation' do
    it 'will not accept invalid product codes' do
      @transaction.input(999)
      expected = 'Product with code 999 does not exist'
      assert(@transaction.prompt.include?(expected))
    end

    it 'will tell you if a product has ran out' do
      @transaction.input(3)
      expected = 'Product chocolate three has ran out'
      assert(@transaction.prompt.include?(expected))
    end
  end
end

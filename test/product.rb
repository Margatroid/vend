require_relative '../lib/product'
require 'minitest/autorun'

describe Product do
  before do
    @product = Product.new('Kinder Egg', 99)
  end

  it 'has name and price' do
    @product.name.must_equal('Kinder Egg')
    @product.price.must_equal(99)
  end
end

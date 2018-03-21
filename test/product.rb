require 'product'
require 'minitest/autorun'

describe Product do
  before do
    @product = Product.new('Kinder Egg', 99, 200)
  end

  it 'has name, price and quantity' do
    @product.name.must_equal('Kinder Egg')
    @product.price.must_equal(99)
    @product.quantity.must_equal(200)
  end
end

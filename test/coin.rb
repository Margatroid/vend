# frozen_string_literal: true

require 'coin'
require 'minitest/autorun'

describe Coin do
  before do
    @coin = Coin.new(100, 2)
  end

  it 'has a denomination' do
    @coin.denomination.must_equal(100)
  end

  it 'has a quantity' do
    @coin.quantity.must_equal(2)
  end

  it 'have the correct denomination' do
    assert_raises(ArgumentError) do
      Coin.new(99)
    end
  end
end

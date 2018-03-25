# frozen_string_literal: true

require 'coin'
require 'exceptions/insufficient_change'
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

describe 'change' do
  before do
    @pool = [
      Coin.new(10, 1),
      Coin.new(5, 5),
      Coin.new(2, 0),
      Coin.new(1, 1)
    ]
  end

  it 'will calculate change' do
    change = Coin.change(@pool, 6)
    assert_equal(2, change.length)
    assert_equal(6, Coin.sum(change))
  end

  it 'can handle zero' do
    assert_empty(Coin.change(@pool, 0))
  end

  it 'will raise an error if there is not enough change available' do
    assert_raises InsufficientChange do
      Coin.change(@pool, 2000)
    end
  end

  it 'can give out several of the same denomination' do
    pool = [
      Coin.new(100, 1),
      Coin.new(50, 0),
      Coin.new(10, 6),
      Coin.new(1, 1000)
    ]
    change = Coin.change(pool, 50)

    assert_equal(5, change.length)
    change.each { |coin| assert_equal(10, coin.denomination) }
  end
end

require 'coin'
require 'minitest/autorun'

describe Coin do
  before do
    @coin = Coin.new(100)
  end

  it 'has a denomination' do
    @coin.denomination.must_equal(100)
  end
end

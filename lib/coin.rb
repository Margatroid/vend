# A single coin
class Coin
  attr_reader :denomination

  def initialize(denomination)
    @denomination = denomination
  end
end

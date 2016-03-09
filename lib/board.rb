# this class represents the card table that includes community cards and pot
class Board
  attr_accessor :cards, :pot

  def initialize
    @cards = []
    @pot   = 0
  end
end

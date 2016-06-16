#Hand class

class Hand
  def initialize(cards, community_cards)
    @hand = cards + community_cards
  end
end
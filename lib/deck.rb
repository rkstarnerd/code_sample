require './player'
require './board'

# this class represents the deck
class Deck
  attr_reader :deck, :suits, :values

  def initialize
    @suits  = Constants::SUITS
    @values = Constants::VALUES
    @deck   = suits.product(values)
  end

  def shuffle!
    4.times { deck.shuffle! }
  end

  def deal(cards)
    cards << deck.shift
  end

  def tell_hand(cards)
    hand = []
    cards.each { |card| hand << ["#{card[1]} of #{card[0]}"] }
    hand = hand.insert(-2, 'and').join(', ')
    puts "\tYour hand includes the #{hand}.\n"
  end

  def flop(community_cards)
    burn_card
    3.times { deal(community_cards) }
    tell_hand(community_cards)
  end

  def turn_river(community_cards)
    burn_card
    deal(community_cards)
    tell_hand(community_cards)
  end

  private

  def burn_card
    deck.delete_at(0)
  end
end

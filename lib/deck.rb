require_relative 'resources/constants'

# this class represents the deck
class Deck
  attr_reader :deck

  def initialize
    suits  = Constants::SUITS
    values = Constants::VALUES
    @deck  = suits.product(values)
  end

  def shuffle!
    4.times { deck.shuffle! }
  end

  def deal(cards)
    cards << deck.shift
  end

  def tell_hand(cards)
    hand = []
    cards.each { |card| hand << "#{card[1]} of #{card[0]}" } 

    hand = 
      case
      when cards.count == 2
        hand.insert(1, 'and')
      when cards.count > 2
        hand.each { |card| card.insert(-1, ',') if card != hand.last }
        hand.insert(-2, 'and')
      else
        hand
      end

    puts "\tYour hand includes the #{hand * ' '}.\n"
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

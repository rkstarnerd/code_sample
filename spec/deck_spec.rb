require 'rspec'
require 'deck'

describe Deck do
  before { @deck = Deck.new}

  it 'initializes with a full deck of 52 cards' do
    expect(@deck.deck.count).to       eq(52)
    expect(@deck.deck.uniq.count).to  eq(52)
  end

  it 'shuffles the cards' do
    first_deck  = Deck.new.deck
    second_deck = Deck.new.deck

    expect(first_deck).to     eq(second_deck)
    expect(first_deck).to_not eq(second_deck.shuffle!)
  end

  it 'takes cards from the deck to populate a hand of cards' do
    first_card = @deck.deck.first
    cards = @deck.deal([])

    expect(cards.flatten).to eq(first_card)
    expect(cards.count).to   eq(1)
  end

  
  [
    [[Deck.new.deck.first], "\tYour hand includes the 2 of Hearts.\n"],
    [Deck.new.deck.first(2), "\tYour hand includes the 2 of Hearts and 3 of Hearts.\n"],
    [Deck.new.deck.first(3), "\tYour hand includes the 2 of Hearts, 3 of Hearts, and 4 of Hearts.\n"]
  ].each do |cards, output|
    it 'prints cards in the hand' do
      expect(STDOUT).to receive(:puts).with(output)
      @deck.tell_hand(cards)
    end
  end

  it 'deals the flop and prints cards in the community cards' do
    first_card = @deck.deck.first

    expect(STDOUT).to receive(:puts).with("\tYour hand includes the 3 of Hearts, 4 of Hearts, and 5 of Hearts.\n")

    @deck.flop([])

    expect(@deck.deck).to_not include(first_card)
  end

  it 'deals the turn or river and prints cards in the community cards' do
    first_card = @deck.deck.first

    expect(STDOUT).to receive(:puts).with("\tYour hand includes the 3 of Hearts.\n")

    @deck.turn_river([])

    expect(@deck.deck).to_not include(first_card)
  end
end
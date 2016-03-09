class Player
  attr_accessor :cards, :chips

  def initialize
    @cards = []
    @chips = 500
  end

  def evaluate(cards, community_cards)
    hand = cards + community_cards

    hand_suits  = hand.map { |card| card[0] }
    hand_values = hand.map { |card| card[1] }

    suit_count = Hash.new(0)
    hand_suits.map { |suit| suit_count[suit] += 1 }

    value_count = Hash.new(0)
    hand_values.map { |value| value_count[value] += 1 }

    flush = hand.select { |card| card if card[0] == suit_count.key(5) }
    pairs = hand.select { |card| card if card[1] == value_count.key(2) }

    best_hand = get_best_hand(suit_count, hand, flush, value_count, pairs)
    rank(suit_count, value_count, best_hand, flush, pairs)
  end

  private

  def get_best_hand(suit_count, hand, flush, value_count, pairs)
    if straight_flush?(suit_count, flush)
      puts "\tStraight flush with these cards: \n\t#{flush.join(', ')}!"
      hand = flush
    elsif four_of_a_kind?(value_count)
      four_of_a_kind = hand.select { |card| card if card[1] == value_count.key(4) }
      puts "\tFour of a kind with these cards:\n\t#{four_of_a_kind.join(', ')}."
      hand = four_of_a_kind
    elsif full_house?(value_count)
      full_house = hand.select { |card| card if (card[1] == value_count.key(3)) || (card[1] == value_count.key(2)) }
      puts "\tFull house with these cards: \n\t#{full_house.join(', ')}."
      hand = full_house
    elsif flush?(suit_count)
      puts "\tFlush with these cards \n\t#{flush.join(', ')}."
      hand = flush
    elsif straight?(hand)
      puts straight?(hand).join(', ')
      hand = straight?(hand)
    elsif three_of_a_kind?(value_count)
      three_of_a_kind = hand.select { |card| card if card[1] == value_count.key(3) }
      puts "\tThree of a kind with these cards: \n\t#{three_of_a_kind.join(', ')}."
      hand = three_of_a_kind
    elsif two_pair?(pairs)
      puts "\tTwo pair with these cards: \n\t#{pairs.join(', ')}."
      hand = pairs
    elsif one_pair?(pairs)
      puts "\tOne pair with these cards: \n\t\t#{pairs.join(', ')}."
      hand = pairs
    else
      puts high_card(hand)
    end

    hand
  end

  def ranks
    Hash[Deck::VALUES.zip Deck::RANGE_FOR_CARDS]
  end

  def rank_cards(hand)
    ranked_cards = {}
    hand.map { |card| ranked_cards[card] = ranks.values_at(card[1]) }
    ranked_cards
  end

  def sorted_rankings(hand)
    rank_cards(hand).values.flatten.sort
  end

  def straight_flush?(suit_count, flush)
    flush?(suit_count) && straight?(flush)
  end

  def four_of_a_kind?(value_count)
    value_count.value?(4)
  end

  def full_house?(value_count)
    value_count.value?(3) && value_count.value?(2)
  end

  def flush?(suit_count)
    suit_count.value?(5)
  end

  def straight?(hand)
    consecutive = []
    straight_rankings = []
    sorted_rankings(hand).uniq.each_cons(5) { |ranking| consecutive << ranking.to_a }
    get_groups_of_five(consecutive)
    get_highest_value(straight_rankings)
  end

  def get_groups_of_five(consecutive)
    unless consecutive.empty?
      consecutive.select { |straight| straight if straight.each_cons(2).all? { |a, b| b == a + 1 } }
    end
  end

  def get_highest_value(straight_rankings)
    unless straight_rankings.empty?
      straight_rankings.sort.last.map { |ranking| rank_cards(hand).key([ranking]) }
    end
  end

  def three_of_a_kind?(value_count)
    value_count.value?(3)
  end

  def two_pair?(pairs)
    pairs.size == 4
  end

  def one_pair?(pairs)
    pairs.size == 2
  end

  def high_card(hand)
    high_card = rank_cards(hand).key([sorted_rankings(hand).last])
    puts "\tHigh card is the #{high_card[1]} of #{high_card[0]}."
  end

  def rank(suit_count, value_count, hand, flush, pairs)
    hand_rank = get_hand_rank(suit_count, hand, flush, value_count, pairs)
    high_card = rank_cards(hand).key([sorted_rankings(hand).last])
    high_card_value = ranks.values_at(high_card[1])
    [hand_rank, high_card_value].flatten
  end

  def get_hand_rank(suit_count, hand, flush, value_count, pairs)
    if straight_flush?(suit_count, flush)
      9
    elsif four_of_a_kind?(value_count)
      8
    elsif full_house?(value_count)
      7
    elsif flush?(suit_count)
      6
    elsif straight?(hand)
      5
    elsif three_of_a_kind?(value_count)
      4
    elsif two_pair?(pairs)
      3
    elsif one_pair?(pairs)
      2
    else
      1
    end
  end
end

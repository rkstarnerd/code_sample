require_relative 'player'
require_relative 'board'
require_relative 'deck'

#This class orchestrates the game
class Game
  attr_accessor :player_one, :computer, :community, :deck

  def initialize
    @player_one = Player.new
    @computer   = Player.new
    @community  = Board.new
    @deck       = Deck.new
  end

  def run
    deck.shuffle!
    2.times { deck.deal(player_one.cards) }
    2.times { deck.deal(computer.cards) }
    deck.tell_hand(player_one.cards)
    prompt
  end

  private

  def prompt
    puts "\t\tWhat would you like to do?"
    options
    selected_option = gets.chomp
    perform(selected_option)
  end

  def options
    if player_one.chips > 0
      puts "\t    Bet: 1, Raise: 2, Check: 3, Fold: 4\n"
    else
      puts 'Check: 3, Fold: 4'
    end
  end

  def perform(selected_option)
    if selected_option == '1' || selected_option == '2'
      puts "You currently have #{player_one.chips} chips."
      puts "How much would you like to bet/raise?"
      amount = gets.chomp.to_i
      make_player_bet(selected_option, amount)
    elsif selected_option == '3'
      computer_turn(selected_option, amount)
      community_turn(community.cards)
    elsif selected_option == '4'
      play_again(player_one.chips)
    else
      puts 'Please enter a valid response.'
      prompt
    end
  end

  def play_again(chips)
    puts "You walk away with #{chips} in chips."
    puts "Would you like to play again?"
    answer = gets.chomp.upcase

    if answer.start_with? 'Y'
      Game.new.run
    else
      puts "Thanks for playing!"
    end
  end

  def computer_turn(selected_option, amount)
    if selected_option == '1' || selected_option == '2'
      make_computer_bet(amount)
    else
      puts 'The computer checks'
    end
  end

  def make_computer_bet(amount)
    puts 'The computer calls.'
    computer.chips = computer.chips - amount
    community.pot = community.pot + amount
    puts "The pot is now at #{community.pot}"
  end

  def make_player_bet(selected_option, amount)
    if amount > player_one.chips
      puts "You don\'t have enough chips to bet that amount."
      perform(selected_option)
    else
      player_one.chips = player_one.chips - amount
      community.pot = community.pot + amount
      puts "The pot is now at #{community.pot}"
      computer_turn(selected_option, amount)
      community_turn(community.cards)
    end
  end

  def community_turn(community_cards)
    if community_cards.empty?
      deck.flop(community_cards)
      player_one.evaluate(player_one.cards, community_cards)
      prompt
    elsif community_cards.size == 3 || community_cards.size == 4
      deck.tell_hand(player_one.cards)
      deck.turn_river(community_cards)
      player_one.evaluate(player_one.cards, community_cards)
      prompt
    else
      puts 'Player has:'
      player_rank = player_one.evaluate(player_one.cards, community_cards)
      puts 'Computer has:'
      computer_rank = computer.evaluate(computer.cards, community_cards)
      check_winner(player_rank, computer_rank)
    end
  end

  def check_winner(player_rank, computer_rank)
    if player_rank[0] > computer_rank[0]
      puts "You win!"
      puts "You walk away with #{player_one.chips + community.pot} chips!"
    elsif player_rank[0] < computer_rank[0]
      puts "Womp! You've lost this hand. You have #{player_one.chips} chips."
    elsif player_rank[1] > computer_rank[1]
      puts "You win!"
      puts "You walk away with #{player_one.chips + community.pot} chips!"
    elsif player_rank[1] < computer_rank[1]
      puts "Womp! You've lost this hand. You have #{player_one.chips} chips."
    else
      puts "\n\t	It's a tie.  You split the pot and walk away with #{player_one.chips +
      (community.pot / 2)}"
    end
  end
end
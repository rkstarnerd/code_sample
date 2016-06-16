require 'rspec'
require 'board'

describe Board do
  it 'initializes with an empty card array instance' do
    board = Board.new
    expect(board.cards).to eq([])
  end

  it 'initializes with an instance of pot set to 0' do
    board = Board.new
    expect(board.pot).to eq(0)
  end
end

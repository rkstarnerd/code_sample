require 'rspec'
require 'board'

describe Board do
  before { @board = Board.new }

  it 'initializes with an empty card array instance' do
    expect(@board.cards).to eq([])
  end

  it 'initializes with an instance of pot set to 0' do
    expect(@board.pot).to eq(0)
  end
end

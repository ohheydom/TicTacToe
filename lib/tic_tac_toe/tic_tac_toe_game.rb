class TicTacToeGame
  attr_accessor :current_turn, :game_board
  attr_reader :check_winner, :computer_ai
  include Constants

  def initialize(game_board = GameBoard.new, check_winner = CheckWinner, computer_ai = ComputerAI)
    @game_board = game_board
    @check_winner = check_winner
    @computer_ai = computer_ai
    @current_turn = X
  end

  def board
    game_board.board
  end

  def move(location)
    switch_turn if game_board.move(location, current_turn)
    board
  end

  def win?(turn = previous_turn)
    check_winner.new(board, turn).win?
  end

  def computer_move
    computer_ai.new(game_board, O, check_winner).best_move
  end

  def previous_turn
    current_turn == X ? O : X
  end

  def remaining_moves
    game_board.remaining_indices_count
  end

  def clear
    game_board.board = Array.new(9, '-')
    @current_turn = X
  end

  private

  def switch_turn
    @current_turn = current_turn == X ? O : X
  end
end

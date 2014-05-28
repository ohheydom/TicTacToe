class ComputerAI
  attr_reader :game_board, :turn, :check_winner, :old_board
  CORNERS = [0, 2, 6, 8]
  SIDES = [3, 1, 5, 7]
  X = 'x'
  O = 'o'

  def initialize(game_board, turn, check_winner)
    @game_board = game_board
    @old_board = game_board.board.dup
    @turn = turn
    @check_winner = check_winner
  end

  def human_player
    turn == O ? X : O
  end

  def best_move
    if five_and_seven? || two_and_seven? || zero_and_seven? || four_and_eight?
      play_to_win || play_to_stop_human_win || play_center || play_reverse_corner || play_side || 0
    elsif includes_side?
      play_to_win || play_to_stop_human_win || play_center || play_corner || play_side || 0
    else
      play_to_win || play_to_stop_human_win || play_center || play_side || play_corner || 0
    end
  end

  private

  def includes_side?
    SIDES.push(4).map { |ind| game_board.board[ind] }.any? { |square| square == human_player }
  end

  def four_and_eight?
    game_board.board[8] == human_player && game_board.board[4] == human_player
  end

  def two_and_seven?
    game_board.board[2] == human_player && game_board.board[7] == human_player
  end

  def five_and_seven?
    game_board.board[5] == human_player && game_board.board[7] == human_player
  end

  def zero_and_seven?
    game_board.board[0] == human_player && game_board.board[7] == human_player
  end

  def play_to_win
    winning_move = game_board.remaining_indices.select do |move|
      game_board.move(move, turn)
      win = check_winner.new(game_board.board, turn).win?
      rollback_board
      win
    end
    winning_move.empty? ? nil : winning_move.first
  end

  def play_to_stop_human_win
    stop_human_move = game_board.remaining_indices.select do |move|
      game_board.move(move, human_player)
      win = check_winner.new(game_board.board, human_player).win?
      rollback_board
      win
    end
    stop_human_move.empty? ? nil : stop_human_move.first
  end

  def play_center
    move = game_board.move(4, turn) ? 4 : nil
    rollback_board
    move
  end

  def play_corner
    move = CORNERS.select { |ind| game_board.move(ind, turn) }.first
    rollback_board
    move
  end

  def play_reverse_corner
    move = CORNERS.reverse.select { |ind| game_board.move(ind, turn) }.first
    rollback_board
    move
  end


  def play_side
    move = SIDES.select { |ind| game_board.move(ind, turn) }.first
    rollback_board
    move
  end

  def rollback_board
    game_board.board = old_board.dup
  end
end

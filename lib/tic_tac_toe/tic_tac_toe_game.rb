class TicTacToeGame
  attr_accessor :current_turn
  attr_reader :check_winner, :computer_ai
  X = 'x'
  O = 'o'

  def initialize(game_board = GameBoard.new, check_winner = CheckWinner, computer_ai = ComputerAI)
    @game_board = game_board
    @check_winner = check_winner
    @computer_ai = computer_ai
    @current_turn = X
  end

  def board
    @game_board.board
  end

  def cycle_through_moves
    all_moves = [*0..8].permutation.to_a
    all_moves.first(5000).map do |numbers|
      numbers.each_with_object({}) do |num, obj| 
        if board.count('-') == 0
          clear
          break nil
        end
        if current_turn == 'x'
          move(num)
          if win?
            obj[board] = previous_turn
            clear
            break obj
          end
        else
          move(computer_move)
          if win?
            clear
            break nil
          end
          redo
        end
      end
    end.compact
  end

  def move(location)
    if @game_board.move(location, @current_turn)
      switch_turn
    end
    @game_board.board
  end

  def win?(turn = previous_turn)
    check_winner.new(board, turn).win?
  end

  def computer_move
    computer_ai.new(@game_board, O, check_winner).best_move
  end

  def previous_turn
    @current_turn == X ? O : X
  end

  def remaining_moves
    @game_board.remaining_indices_count
  end

  def clear
    @game_board = GameBoard.new
    @current_turn = X
  end

  private

  def switch_turn
    @current_turn = @current_turn == X ? O : X
  end
end

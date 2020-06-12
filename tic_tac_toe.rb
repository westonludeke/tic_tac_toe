=begin  ---- A single player Tic Tac Toe game ----

 ---- GAME NOTES ----
1. Instead of manually choosing who goes first /
   each round alternates between the player choosing first and the computer.

2. The computer always makes the most optimal choice for the computer.
  2a. This means always selecting space #5 if available.

=end

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINS_NEEDED_TO_WIN_GAME = 5

keep_score = { 'player_score' => 0, 'computer_score' => 0, \
               'tie_games' => 0, "rounds_played" => 0, "beginner" => "" }

def prompt(msg)
  puts "=> #{msg}"
end

def welcome
  prompt "Welcome to Tic Tac Toe!"
  prompt "First to win #{WINS_NEEDED_TO_WIN_GAME} rounds wins the game."
  sleep 3
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
# This displays the Tic Tac Toe board
def display_board(brd)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

# This creates a new, empty board to start the round
def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

# This makes all of the squares on the board empty
def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

# This method cleans up the prompt, listing the empty squares available.
def joinor(arr, punc = ", ", or_and = "or")
  new_arr = []
  arr.map!(&:to_s)
  last = arr.pop
  if arr.length > 1
    arr.each { |value| new_arr << value + punc }
  else
    arr.each { |value| new_arr << value + " " }
  end

  new_arr << if arr.empty?
               last
             else
               or_and + " " + last
             end
  new_arr.join("")
end

def who_starts(keep_score)
  keep_score["beginner"] = if keep_score["rounds_played"].even?
                             'Player'
                           else
                             'Computer'
                           end
end
who_starts(keep_score)

# ---- PLAYER SELECTIONS ----
def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Player, choose a square: #{joinor(empty_squares(brd))}:"
    square = gets.chomp.to_f
    break if empty_squares(brd).include?(square) && square % 1 == 0
    prompt "Sorry, that's not a valid choice."
  end
  brd[square.to_i] = PLAYER_MARKER
end

# ---- COMPUTER SELECTIONS ----
def computer_selects_five(brd)
  if brd.values_at(5)[0] == ' '
    square = 5
    brd[square] = COMPUTER_MARKER
  end
end

def computer_choice(brd, line)
  line.each do |comp_choice|
    if brd.key?(comp_choice) && brd.values_at(comp_choice)[0] == " "
      square = comp_choice
      brd[square] = COMPUTER_MARKER
    end
  end
end

def computer_marks_board(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def x_greater_than_o(brd)
  brd.values.count('X') > brd.values.count('O')
end

def x_even_with_o(brd)
  brd.values.count('X') == brd.values.count('O')
end

def computer_random_choice(brd, keep_score)
  if keep_score["beginner"] == 'Player' && \
     x_greater_than_o(brd)
    computer_marks_board(brd)
  elsif keep_score["beginner"] == 'Computer' && \
        x_even_with_o(brd)
    computer_marks_board(brd)
  end
end

# ----- COMPUTER GOES FOR THE WIN ----
def computer_two_spaces_filled(brd, line)
  brd.values_at(*line).count(COMPUTER_MARKER) == 2 && \
    brd.values_at(*line).count(PLAYER_MARKER) == 0
end

def computer_win(brd, line)
  if computer_two_spaces_filled(brd, line) && \
     (x_greater_than_o(brd))
    computer_choice(brd, line)
  elsif computer_two_spaces_filled(brd, line) && \
        (x_even_with_o(brd))
    computer_choice(brd, line)
  end
end

def computer_seals_victory(brd, keep_score)
  WINNING_LINES.each do |line|
    if keep_score["beginner"] == 'Player'
      computer_win(brd, line)
    elsif keep_score["beginner"] == 'Computer'
      computer_win(brd, line)
    end
  end
end

# ---- COMPUTER BLOCKS PLAYER VICTORY
def player_one_square_away(brd, line)
  brd.values_at(*line).count(PLAYER_MARKER) == 2 && \
    brd.values_at(*line).count(COMPUTER_MARKER) == 0
end

def rounds_played_even(brd, line)
  if x_greater_than_o(brd)
    computer_choice(brd, line)
  end
end

def rounds_played_odd(brd, line)
  if x_even_with_o(brd)
    computer_choice(brd, line)
  end
end

def computer_blocks_player(brd, keep_score)
  WINNING_LINES.each do |line|
    if player_one_square_away(brd, line)
      if keep_score["rounds_played"].even?
        rounds_played_even(brd, line)
      elsif keep_score["rounds_played"].odd?
        rounds_played_odd(brd, line)
      end
    end
  end
end
# ----

def computer_places_piece!(brd, keep_score)
  computer_selects_five(brd)
  computer_seals_victory(brd, keep_score)
  computer_blocks_player(brd, keep_score)
  computer_random_choice(brd, keep_score)
  display_board(brd)
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

# ---- SCORING AND GAMEPLAY ----
def beginning_round_prompt(keep_score)
  if keep_score["rounds_played"] == 0
    welcome
  end
  prompt "#{keep_score['rounds_played']} rounds have been played so far."
  prompt "The #{keep_score['beginner']} will start off this round!"
  sleep 3
end

def begin_player_loop(board, keep_score)
  loop do
    display_board(board)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)

    computer_places_piece!(board, keep_score)
    break if someone_won?(board) || board_full?(board)
  end
end

def begin_computer_loop(board, keep_score)
  loop do
    display_board(board)

    computer_places_piece!(board, keep_score)
    break if someone_won?(board) || board_full?(board)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
    display_board(board)
  end
end

def selection_loop(board, keep_score)
  if keep_score["beginner"] == 'Player'
    begin_player_loop(board, keep_score)
  elsif keep_score["beginner"] == 'Computer'
    begin_computer_loop(board, keep_score)
  end
  display_board(board)
end

def winner_round_prompt(board, keep_score)
  prompt "The #{detect_winner(board)} won this round!"
  if detect_winner(board) == 'Player'
    keep_score['player_score'] += 1
  elsif detect_winner(board) == 'Computer'
    keep_score['computer_score'] += 1
  end
end

def display_tie_round_prompt(keep_score)
  keep_score['tie_games'] += 1
  prompt "It's a tie!"
end

def score_check(keep_score)
  if keep_score['player_score'] < WINS_NEEDED_TO_WIN_GAME && \
     keep_score['computer_score'] < WINS_NEEDED_TO_WIN_GAME
    display_end_round_prompt(keep_score)
  else
    prompt "We have game winner! Calculating final scores now..."
  end
  sleep 5
end

def display_end_round_prompt(keep_score)
  prompt "The Player currently has #{keep_score['player_score']} wins. " \
  "The computer has #{keep_score['computer_score']} wins. " \
  "There have been #{keep_score['tie_games']} ties. "
  prompt "The next round will begin soon!"
  who_starts(keep_score)
end

def end_round_score_update(keep_score)
  keep_score["rounds_played"] = (keep_score['player_score'] + \
  keep_score['computer_score'] + keep_score['tie_games'])
end

def winner_check(keep_score)
  if keep_score['player_score'] == WINS_NEEDED_TO_WIN_GAME
    prompt "The player has won the game with #{keep_score['player_score']} " \
    "wins against the computer's #{keep_score['computer_score']} "\
    "wins and #{keep_score['tie_games']} ties. " \
    "Good job!"
  elsif keep_score['computer_score'] == WINS_NEEDED_TO_WIN_GAME
    prompt "The computer has won the game with " \
    "#{keep_score['computer_score']} victories " \
    "against your #{keep_score['player_score']} wins " \
    "and #{keep_score['tie_games']} ties. " \
    "Better luck next time."
  else
    false
  end
end

def play(keep_score)
  until winner_check(keep_score) != false
    beginning_round_prompt(keep_score)
    board = initialize_board
    selection_loop(board, keep_score)

    if someone_won?(board)
      winner_round_prompt(board, keep_score)
    else
      display_tie_round_prompt(keep_score)
    end
    end_round_score_update(keep_score)
    score_check(keep_score)
  end
  play_again(keep_score)
end

def play_again(keep_score)
  keep_score["rounds_played"] = 0
  prompt "Would you like to play again? (y or n)"
  answer = gets.chomp
  if answer.downcase == ('y') || answer.downcase == ('yes')
    keep_score['player_score'] = 0
    keep_score['computer_score'] = 0
    keep_score['tie_games'] = 0
    play(keep_score)
  else
    prompt "Thanks for playing Tic Tac Toe! Goodbye!"
  end
end

play(keep_score)

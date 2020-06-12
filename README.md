# Tic Tac Toe
##### *A game of Tic Tac Toe in Ruby*

![image](https://i.imgur.com/SEKGEa2.png)

### About:

This program is a Tic Tac Toe game in Ruby and was built as part of the Launch School RB101 course. The initial logic of displaying the board and both users making selections was designed by the Launch School teachers. 

As part of the course, my role was to develop the following logic:

* Keeping score at the end of each round.
* The ability to have multiple rounds needed to win the game.
* The computer making smart selections, including both going for the win and blocking the player from winning.
* Alternating which user (player or computer) begin the round.
* Repeating the game after a winner is declared.


### Game Notes:

This version of Tic Tac Toe is only in Ruby and there is no front end. In order to play the game, you will need to download the file and run the Ruby program from the command line.

The game is designed for the player and the computer to alternate who starts each round. At the end of the round, there will be one of three outcomes: The player wins, the computer wins, or there is a tie. The terminal will keep score and also a total number of rounds played.

The first person to win 5 rounds wins the game. This can be adjusted in the "WINS_NEEDED_TO_WIN_GAME" constant if you'd like to play less rounds or more rounds.

The computer will always make the most optimal selection for the computer to win the round. The computer's logic is designed to always make it's selection in the following order:

1. **Select square number '5'** - If the middle square is available, the computer will always select this square first. This square gives the most options to win the round.

2. **Computer Seals Victory** - If the computer has two consecutive squares filled out, and the next square is available, the computer will go for the win. The computer will always choose to go for the win, if available, as opposed to moving to block the player.

3. **Computer Blocks Player** - If the player has two consecutive squares filled out, and is one square away from winning the round, the computer will always move to block the player. This is only *if* the computer cannot go for the win itself.

4. **Computer Random Selection** - If none of the above are available options for the computer, the computer will simply make a random selection on the board.

At the end of the game, there is an option to play again which resets the scores.

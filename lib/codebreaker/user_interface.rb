require_relative 'game'

module Codebreaker
  class UserInterface
    def main_menu
      puts '***Welcome to the Codebreaker game!***'
      puts "Enter any character to start playing or 'exit' for exit"
      gets.chomp == 'exit' ? bye : play
    end

    def play
      @game = Game.new
      start_game_message
      while attempts?
        puts "You used #{@game.used_attempts} attempts." if @game.used_attempts > 0
        input = gets.chomp
        if input == 'h'
          hint = @game.hint
          puts hint
        else
          result = @game.make_guess(input)
          puts result
        end
        break if won?(result)
      end
      lost unless attempts?
      score
      save_or_again
    end

    private

    def start_game_message
      puts "Please, enter your code to make guess or 'h' to get a hint"
      puts "You have #{Game::ATTEMPTS} attempts"
    end

    def attempts?
      @game.used_attempts < Game::ATTEMPTS
    end

    def won?(result)
      return false unless result == '++++'
      puts '***Congratulations, you won!***'
      @game_status = 'won'
      true
    end

    def lost
      puts 'No more attempts. You lost :('
      @game_status = 'lost'
    end

    def score
      puts "Attempts used: #{@game.used_attempts}"
      puts "Hints used: #{@game.used_hints}"
    end

    def save_or_again
      puts 'Do you want to play again(y/n) or save score(s)?'
      choise = gets.chomp

      if choise == 'y' then play end
      if choise == 'n' then bye end
      if choise == 's'
        name = ask_name
        @game.save_result(username: name, game_status: @game_status)
        puts 'Your result has been saved'
      else
        puts 'Your result has been saved'
        @game.save_result(username: 'Unkwnown player', game_status: @game_status)
      end
      main_menu
    end

    def ask_name
      puts 'Please, type your name:'
      gets.chomp
    end

    def bye
      puts 'Bye!'
      exit
    end
  end
end
# ui = Codebreaker::UserInterface.new
# ui.main_menu

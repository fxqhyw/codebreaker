require_relative 'game'

module Codebreaker
  class UserInterface
    def main_menu
      puts '***Welcome to the Codebreaker game!***'
      puts "Enter any character to start playing or 'exit' for exit"
      gets.chomp == 'exit' ? bye : play
    end

    private

    def play
      @game = Game.new
      start_game_message
      while attempts?
        puts "You used #{@game.used_attempts} attempts."
        input = gets.chomp
        if input == 'h'
          puts @game.hint
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

    def start_game_message
      puts "Please, enter your code to make guess or 'h' to get a hint"
      puts "You have #{Game::ATTEMPTS} attempts"
    end

    def attempts?
      @game.used_attempts != Game::ATTEMPTS
    end

    def won?(result)
      return false unless result == '++++'
      puts '***Congratulations, you won!***'
      true
    end

    def lost
      puts 'No more attempts. You lost :('
    end

    def score
      puts "Attempts used: #{@game.used_attempts}"
      puts "Hints used: #{@game.used_hints}"
    end

    def save_or_again
      puts 'Do you want to play again(y/n) or save score(s)?'
      choise = gets.chomp[/^[yns]/]

      if choise == 'y' then start end
      if choise == 'n' then bye end
      if choise == 's'
        name = ask_name
        save_result(name)
        puts 'Your result has been saved'
        main_menu
      else
        puts 'Please, make your choice!'
         save_or_again
      end
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

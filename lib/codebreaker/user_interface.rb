require_relative 'game'

module Codebreaker
  class UserInterface
    def main_menu
      puts '***Welcome to the Codebreaker game!***'
      puts "Enter any character to start playing or 'exit' for exit\n"
      gets.chomp == 'exit' ? bye : start
    end

    private

    def start
      @game = Game.new
      start_game_message
      until @game.available_attempts.zero?
        puts "You have #{@game.available_attempts} available attempts"
        input = gets.chomp
        puts @game.hint if input == 'h'
        result = @game.make_guess(input)
        puts result
        break if won?(result)
      end
      lost if @game.available_attempts.zero?
      score
      save_or_again
    end

    def start_game_message
      puts "Please, enter your code to make guess or 'h' to get a hint\n"
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
      puts "Attempts used: #{10 - @game.available_attempts}\n"
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
ui = Codebreaker::UserInterface.new
ui.main_menu

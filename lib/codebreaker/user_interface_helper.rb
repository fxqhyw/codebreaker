require_relative 'game'

module UiHelper
  def greeting_message
    puts '***Welcome to the Codebreaker game!***'
    puts "Enter any characters to start playing or 'exit' for exit"
  end

  def start_game_message
    puts "Please, enter your code to make guess or 'h' to get a hint"
    puts "You have #{Codebreaker::Game::ATTEMPTS} attempts and #{Codebreaker::Game::HINTS} hints"
  end

  def no_hints_message
    puts 'You used all of hints!'
  end

  def won_message
    puts '***Congratulations, you won!***'
  end

  def lost_message
    puts 'You used all of attempts. You lost :('
  end

  def ask_name
    puts 'Please, type your name:'
    gets.chomp
  end

  def saved_result_message
    puts 'Your result has been saved'
  end

  def bye
    puts 'Bye!'
    exit
  end
end
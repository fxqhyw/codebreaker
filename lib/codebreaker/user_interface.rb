require_relative 'game'
require_relative 'user_interface_helper'

module Codebreaker
  class UserInterface
    include UiHelper

    def main_menu
      greeting_message
      gets.chomp == 'exit' ? bye : play
    end

    def play
      create_new_game
      start_game_message
      playing
      lost unless attempts?
      score
      after_game_menu
    end

    private

    def create_new_game
      @game = Game.new
    end

    def playing
      while attempts?
        used_attempts_message
        input = gets.chomp
        if call_hint?(input)
          show_hint
        else
          result = @game.make_guess(input)
          show_result(result)
        end
        if won?(result)
          won
          break
        end
      end
    end

    def attempts?
      @game.used_attempts < Game::ATTEMPTS
    end

    def hints?
      @game.used_hints < Game::HINTS
    end

    def used_attempts_message
      puts "You used #{@game.used_attempts} attempts." if @game.used_attempts > 0
    end

    def call_hint?(input)
      input.match(/^h$/)
    end

    def show_hint
      hints? ? puts(@game.hint) : no_hints_message
    end

    def show_result(result)
      puts result
    end

    def won?(result)
      return false unless result == '++++'
      true
    end

    def won
      @game_status = 'won'
      won_message
    end

    def lost
      @game_status = 'lost'
      lost_message
    end

    def score
      puts "Attempts used: #{@game.used_attempts}"
      puts "Hints used: #{@game.used_hints}"
    end

    def after_game_menu
      puts 'Do you want to play again(y/n) or save score(s)?'
      choise = gets.chomp[/^[yns]/]

      if choise == 'y' then play end
      if choise == 'n' then bye end
      if choise == 's' then save end
      main_menu
    end

    def save
      name = ask_name
      @game.save_result(username: name, game_status: @game_status)
      saved_result_message
    end
  end
end


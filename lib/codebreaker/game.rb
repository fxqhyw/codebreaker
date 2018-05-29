module Codebreaker
  class Game
    attr_accessor :available_attempts

    def initialize
      @available_attempts = 10
      @used_hints = 0
      @secret_code = generate
    end

    def hint
      @used_hints += 1
      index = rand(0..3)
      @secret_code[index]
    end

    def make_guess(user_code)
      return 'Incorrect code format' unless code_valid?(user_code)
      @available_attempts -= 1
      match_calculation(user_code)
    end

    private

    def generate
      Array.new(4) { rand(1..6) }
    end

    def code_valid?(user_code)
      user_code.match(/^[1-6]{4}$/)
    end

    def match_calculation(user_code)
      user_code = user_code.split('').map(&:to_i)
      return '++++' if user_code == @secret_code

      result = []
      unmatched_exact = @secret_code
      user_code.each_with_index do |el, i|
        if @secret_code[i] == el
          result << '+'
          unmatched_exact.delete_at(i)
        end
      end

      unmatched_numbers = unmatched_exact
      user_code.each_with_index do |el, i|
        if unmatched_numbers.include?(el)
          result << '-'
          unmatched_numbers.delete(el)
        end
      end
      result
    end
  end
end

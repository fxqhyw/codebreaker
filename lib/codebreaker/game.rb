module Codebreaker
  class Game
    attr_accessor :atempts

    def initialize
      @available_atempts = 10
      @used_hints = 0
      @secret_code = generate
    end

    def hint
      @used_hints += 1
      index = rand(0..3)
      @secret_code[index]
    end

    def make_guess(user_code)
      return 'Incorrect format' unless code_valid?(user_input)
    end

    private

    def generate
      Array.new(4) { rand(1..6) }
    end

    def code_valid?(user_code)
      user_code.match(/^[1-6]{4}$/)
    end
  end
end

module Codebreaker
  class Game
    attr_accessor :atempts

    def initialize
      @atempts = 10
      @code = generate
    end

    def generate
      Array.new(4) { rand(1..6) }
    end

    def hint
      index = rand(0..3)
      @secret_code[index]
    end
  end
end

module Codebreaker
  class Game
    def initialize
    end

    def start
      @secret_code = Array.new(4) { rand(1..6) }
    end
  end
end

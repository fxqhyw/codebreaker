module Codebreaker
  class Console
    def initialize
      @game = Game.new
    end

    def start
      puts 'Welcome to the Codebreaker game!'
      puts "1.Start\n"\
           "0.Exit\n"
    end
  end
end

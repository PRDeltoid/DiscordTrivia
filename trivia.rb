require 'discordrb'

class Trivia

  def initialize(bot)
    @running = false
    @bot = bot
  end

  def start
    @running = true;
  end

end

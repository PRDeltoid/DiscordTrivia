require 'discordrb'
require_relative 'trivia'


trivia = Trivia.new()

trivia.bot.command :trivia do |event, command|
  case command 
    when "start"
      trivia.channel = event.channel.id
      trivia.bot.send_message(trivia.channel, "Starting")
      trivia.start
    when "stop"
      trivia.stop
      "Stopping"
    else 
      "Unknown Command"
  end
end


trivia.bot.run



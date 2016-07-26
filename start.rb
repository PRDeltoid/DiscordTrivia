require_relative 'bot'

triviabot = Bot.new(:config_file => 'config.json')

triviabot.bot.command :trivia do |event, command|
  case command 
    when "start"
      "Starting"
      triviabot.channel = event.channel.id
      triviabot.start
    when "stop"
      "Stopping"
      triviabot.stop
    else 
      "Unknown Command"
  end
end

triviabot.bot.run

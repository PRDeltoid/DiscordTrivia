require_relative 'bot'

triviabot = Bot.new(:config_file => 'config.json')

triviabot.bot.command :trivia do |event, command|
  case command 
    when "start"
      triviabot.channel = event.channel.id
      triviabot.start
      return
    when "stop"
      triviabot.stop
      return
    else 
      "Unknown Command"
  end
end

triviabot.bot.run

require 'discordrb'
require 'json'
require './trivia.rb'

json = File.read('config.json')
config = JSON.parse(json)

bot = Discordrb::Commands::CommandBot.new(
  token: config['token'],
  application_id: config['appid'],
  prefix: config['prefix'] 
)

trivia = Trivia.new(bot);

bot.command :trivia do |event, command|
  case command 
    when "start"
      "Starting"
      trivia.start
    else 
      "Unknown Command"
  end
end


bot.run



require 'discordrb'
require 'json'

json = File.read('config.json')
config = JSON.parse(json)

bot = Discordrb::Commands::CommandBot.new(
  token: config['token'],
  application_id: config['appid'],
  prefix: '!'
)

bot.command :test do |event|
  'hello'
end


bot.run

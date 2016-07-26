require 'json'
require 'discordrb'
require_relative 'trivia'

class Bot 
  attr_accessor :bot, :trivia, :channel, :running

  def initialize(args)
    #read in Discord bot API details
    json = File.read(args.fetch(:config_file, 'config.json'))
    config = JSON.parse(json)

    #generate bot
    @bot = Discordrb::Commands::CommandBot.new(
      token: config['token'],
      application_id: config['appid'],
      prefix: config['prefix'] 
    )

    @trivia = Trivia.new
    @channel = nil
    @running = false
  end

  def start
    send_message "Starting"
    running = true;
    setup_question(trivia.get_question)
  end

  def stop
    running = false;
  end

  def setup_question(question)
    send_message(question.question)

    bot.add_await(:question, Discordrb::Events::MessageEvent, {content: question.answer}) do |event|
      send_message "Correct"
    end
  end

  def send_message(message)
    bot.send_message(channel, message)
  end

end

require 'json'
require 'discordrb'
require_relative 'trivia'
require_relative 'messenger'
#require_relative 'score'

class Bot 
  attr_accessor :bot, :trivia, :channel, :running, :messenger

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

  def running?
    self.running ? true : false
  end

  def start
    #only run this method if trivia is NOT already running
    if not running?
      self.running = true
      @messenger = Messenger.new(self)
      messenger.send_message "Starting"
  
      setup_question
    end
  end

  def stop
    #only run this method if trivia is already running
    if running?
      self.running = false
    end
  end

  def setup_question()
    question = trivia.get_question
    messenger.send_message(question.question)

    bot.add_await(:question, Discordrb::Events::MessageEvent, {content: question.answer}) do |event|
      messenger.send_message "Correct #{event.user.display_name}."
      self.trivia.get_question.answered = true
    end
  end

end

require 'json'
require 'discordrb'

class Trivia

  attr_accessor :bot, :channel

  def initialize()
    @channel = nil
    json = File.read('config.json')
    config = JSON.parse(json)

    @bot = Discordrb::Commands::CommandBot.new(
      token: config['token'],
      application_id: config['appid'],
      prefix: config['prefix'] 
    )
    @running = false
  end

  def start
    @running = true;
    generate_question
  end

  def stop
    @running = false;
  end

  def generate_question
    @bot.send_message(@channel, "What is Foo")
    @bot.add_await(:question, Discordrb::Events::MessageEvent, {content: "Bar"}) do |event|
      @bot.send_message(@channel, "Correct")
      if @running != false 
        generate_question
      end
    end
  end

end

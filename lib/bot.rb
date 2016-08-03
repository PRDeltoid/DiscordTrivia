require 'json'
require 'discordrb'
require 'rufus-scheduler'
require_relative 'trivia'
require_relative 'messenger'
require_relative 'config'

class Bot
  attr_accessor :bot, :trivia, :channel, :running, :messenger, :scheduler

  def initialize
    #generate bot
    @bot = Discordrb::Commands::CommandBot.new(
      token: $config.get('token'),
      application_id: $config.get('appid'),
      prefix: $config.get('prefix')
    )

    @trivia = Trivia.new
    @channel = nil
    @running = false
    @scheduler = Rufus::Scheduler.new
    @messenger = Messenger.new(self)
  end

  def running?
    self.running ? true : false
  end

  def start
    #only run this method if trivia is NOT already running
    if not running?
      self.running = true
      messenger.set_channel(channel)
      messenger.send_message("Starting")

      setup_question

      scheduler.every '2s' do
        if trivia.answered?
          trivia.next_question
          setup_question
        end
      end

    end
  end

  def stop
    #only run this method if trivia is already running
    if running?
      self.running = false
      scheduler.shutdown
    end
  end

  def setup_question
    question = trivia.get_question

    p question.answer

    #Ask the question
    messenger.send_message(question.question)

    #Question Timeout Timer
    scheduler.in '1m' do
      messenger.send_message("Times up! The answer was #{question.answer}")
      trivia.mark_answered
    end

    #Answer event trigger
    bot.add_await(:question, Discordrb::Events::MessageEvent, {content: /#{question.answer}/i}) do |event|
      if running?
        messenger.send_message("Correct #{event.user.display_name}.")
        trivia.mark_answered
      end
    end
  end

end

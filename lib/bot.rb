require 'json'
require 'discordrb'
require 'rufus-scheduler'
require_relative 'trivia'
require_relative 'messenger'
require_relative 'config'

class Bot
  attr_accessor :command_bot,
                :trivia,
                :running,
                :scheduler

  attr_reader   :messenger

  def initialize
    # Generate bot
    @command_bot = Discordrb::Commands::CommandBot.new(
      token:          Configuration.get('token'),
      application_id: Configuration.get('appid'),
      prefix:         Configuration.get('prefix')
    )

    @messenger  = Messenger.new(self)
    @trivia     = Trivia.new(self, messenger)

    setup_commands
  end

  def setup_commands
    command_bot.command :trivia do |event, command|
      channel_id = event.channel.id
      case command
      when 'start'
        messenger.channel = channel_id
        trivia.start
      when 'stop'
        trivia.stop
      else
        'Unknown Command'
      end
      return
    end
  end

  def add_await(args)
    command_bot.add_await(:question,
                          Discordrb::Events::MessageEvent,
                          content: /#{args[:content]}/i) do |event|
      args[:await_function].call(event)
    end
  end
end

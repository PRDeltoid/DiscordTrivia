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
    #generate bot
    @command_bot = Discordrb::Commands::CommandBot.new(
      token:          $config.get('token'),
      application_id: $config.get('appid'),
      prefix:         $config.get('prefix')
    )

    @messenger  = Messenger.new(self)
    @trivia     = Trivia.new(self, messenger)

    command_bot.command :trivia do |event, command|
      channel_id = event.channel.id
      case command
        when "start"
          messenger.set_channel(channel_id)
          trivia.start
          return
        when "stop"
          trivia.stop
          return
        else
          "Unknown Command"
      end
    end
  end

  def add_await(args)
    command_bot.add_await(:question,
                           Discordrb::Events::MessageEvent, 
                           {content: /#{args[:content]}/i}) { |event|
      args[:await_function].call(event)
    }
  end
end

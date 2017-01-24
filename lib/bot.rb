require 'json'
require 'discordrb'
require 'rufus-scheduler'
require 'observer'
require_relative 'trivia'
require_relative 'messenger'
require_relative 'config'
require_relative 'reporter'

class Bot
  include Observable
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
    @trivia     = Trivia.new(self)
    @reporter   = Reporter.new(self)

    setup_commands
  end

  def setup_commands
    command_bot.command :trivia do |event, command|
      messenger.channel = event.channel.id
      userid = event.message.author.id

      # Notify objects capable of receiving commands
      command_out = { command: command, userid: userid }
      changed
      notify_observers(command_out)
      # Empty return so the bot doesn't output to chat
      # (returned values are normally sent to chat)
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

  def stop
    command_bot.stop
  end
end

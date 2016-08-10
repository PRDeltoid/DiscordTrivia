require 'discordrb'

class Messenger
  attr_accessor :command_bot,
                :channel

  def initialize(trivia_bot)
    @command_bot = trivia_bot.command_bot
  end

  def send_message(message)
    command_bot.send_message(channel, message)
  end

  def set_channel(channel)
    self.channel = channel
  end

end

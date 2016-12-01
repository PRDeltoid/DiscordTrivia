require 'discordrb'

class Messenger
  attr_accessor :command_bot
  attr_reader   :channel

  def initialize(trivia_bot)
    @command_bot = trivia_bot.command_bot
  end

  def send_message(message, emphasis = '')
    return false if message == '' || message.nil?
    message = "#{emphasis}#{message}#{emphasis}"
    command_bot.send_message(channel, message)
  end

  def channel=(channel_set)
    @channel = channel_set
  end
end

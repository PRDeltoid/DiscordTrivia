require 'discordrb'

class Messenger
  attr_accessor :bot, :channel

  def initialize(bot)
    @bot = bot.bot
    @channel = bot.channel
  end

  def send_message(message)
    bot.send_message(channel, message)
  end

  def set_channel(channel)
    self.channel = channel
  end

end

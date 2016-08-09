require 'discordrb'

class Messenger
  attr_accessor :discord_bot, :channel

  def initialize(trivia_bot)
    @discord_bot = trivia_bot.bot
  end

  def send_message(message)
    discord_bot.send_message(channel, message)
  end

  def set_channel(channel)
    self.channel = channel
  end

end

require_relative 'logger'

class Reporter
  attr_accessor :trivia,
                :messenger

  def initialize(bot)
    bot.add_observer(self)
    @trivia = bot.trivia
    @messenger = bot.messenger
  end

  def update(command)
    if command == "report"
      report_string = "#{trivia.current_question.question} - #{trivia.current_question.answer}"
      Logger.log(report_string, :report)
      messenger.send_message("This question has been reported.")
    end
  end
end

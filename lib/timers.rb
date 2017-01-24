class TimerContainer
  attr_accessor :hint_timer,
                :timeout_timer,
                :scheduler,
                :trivia,
                :messenger

  def initialize(trivia)
    @trivia = trivia
    @messenger = trivia.messenger
    @scheduler = trivia.scheduler
  end

  def unschedule_all
    unless hint_timer.nil?
      scheduler.unschedule(hint_timer)
      self.hint_timer = nil
    end
    unless timeout_timer.nil?
      scheduler.unschedule(timeout_timer)
      self.timeout_timer = nil
    end
  end

  def current_question
    return trivia.current_question
  end

  def generate_hint_timer
    seconds = 75 / current_question.hint_num
    p "Seconds: #{seconds}"

    # Print the first (empty) hint and move to the first real hint
    messenger.send_message(current_question.hint, '`')
    current_question.next_hint

    self.hint_timer = scheduler.every "#{seconds}s", 'last_in' => '75s' do
      messenger.send_message(current_question.hint, '`')
      current_question.next_hint
    end
  end

  def generate_question_timer
    self.timeout_timer = scheduler.in '75s' do
      unschedule_all
      messenger.send_message("Times up! The answer was #{current_question.answer}")
      current_question.mark_answered
    end
  end
end

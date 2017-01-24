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
    @hint_timer
    @timeout_timer
  end

  def unschedule_all
    if hint_timer == nil || timeout_timer == nil then return end
    scheduler.unschedule(hint_timer)
    scheduler.unschedule(timeout_timer)
  end

  def current_question
    return trivia.current_question
  end

  def generate_hint_timer
    p "Seconds: #{seconds = 75 / current_question.hint_num}"

    # Print the first (empty) hint and move to the first real hint
    messenger.send_message(current_question.hint, '`')
    current_question.next_hint

    hint_timer = scheduler.every "#{seconds}s", 'last_in' => '75s' do
      messenger.send_message(current_question.hint, '`')
      current_question.next_hint
    end
  end

  def generate_question_timer
    timeout_timer = scheduler.in '1m' do
      messenger.send_message("Times up! The answer was #{current_question.answer}")
      current_question.mark_answered
    end
  end

end

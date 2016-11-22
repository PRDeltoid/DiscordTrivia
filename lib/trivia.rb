require_relative 'question_factory'
require_relative 'scores'

class Trivia
  attr_accessor :question_factory,
                :current_question,
                :running

  attr_reader   :messenger,
                :bot,
                :scheduler,
                :scores

  def initialize(trivia_bot, messenger)
    @question_factory = QuestionFactory.new
    @current_question = nil

    @bot              = trivia_bot
    @messenger        = messenger
    @running          = false
    @scheduler        = Rufus::Scheduler.new
    @scores           = Scores.new
  end

  def start
    # only run this method if trivia is NOT already running
    unless running?
      self.running = true

      messenger.send_message('Starting')

      setup_question

      # Keep checking to see if the current question gets answered
      # so we can ask the next one
      scheduler.every '2s' do
        if current_question.answered?
          next_question
          setup_question
        end
      end

    end
  end

  def stop
    # only run this method if trivia is already running
    if running?
      messenger.send_message('Stopping')
      messenger.send_message(scores.round_scores)

      # RESET EVERYTHING
      scores.merge_into_global
      self.current_question = nil
      self.running = false
      scheduler.jobs.each(&:unschedule)
    end
  end

  def setup_question
    current_question = pull_question
    p current_question.answer # TODO: Remove this

    # Ask the question
    messenger.send_message(current_question.question)

    timeout    = generate_question_timer
    hint_timer = generate_hint_timer

    # Create the answer trigger
    await_function = generate_await_function(timeout, hint_timer)
    bot.add_await(content:        current_question.answer,
                  await_function: await_function)
  end

  def generate_hint_timer
    seconds = 45 / current_question.hint_num

    scheduler.every "#{seconds}s", 'last_in' => '1m' do
      messenger.send_message(current_question.hint)
      current_question.next_hint
    end
  end

  def generate_question_timer
    scheduler.in '1m' do
      messenger.send_message("Times up! The answer was #{current_question.answer}")
      current_question.mark_answered
    end
  end

  def generate_await_function(timeout, hint_timer)
    proc do |event|
      if running?
        messenger.send_message("Correct #{event.user.username}.")
        current_question.mark_answered

        scores.update(event.user, 1) # Hardcoded point value (1)

        scheduler.unschedule(timeout)
        scheduler.unschedule(hint_timer)
      end
    end
  end

  def pull_question
    # Generate question if none exists
    if current_question.nil?
      self.current_question = question_factory.new_question
    else
      current_question
    end
  end

  def next_question
    self.current_question = question_factory.new_question
  end

  def running?
    running ? true : false
  end
end

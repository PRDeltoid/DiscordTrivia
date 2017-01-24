require_relative 'question_factory'
require_relative 'timers'
require_relative 'scores'
require_relative 'voter'

class Trivia
  attr_accessor :question_factory,
                :current_question,
                :running,
                :timers

  attr_reader   :messenger,
                :bot,
                :scheduler,
                :scores,
                :voter

  def initialize(bot)
    @question_factory = QuestionFactory.new
    @current_question = nil

    @bot              = bot
    @messenger        = bot.messenger
    @running          = false
    @scheduler        = Rufus::Scheduler.new
    @scores           = Scores.new
    @timers           = TimerContainer.new(self)
    @voter            = Voter.new

    bot.add_observer(self)
  end

  def update(command_in)
    command = command_in.fetch(:command)
    userid  = command_in.fetch(:userid)
    if command == 'start'
      start
    elsif command == 'stop'
      stop
    elsif command == 'skip'
      skip(userid)
    elsif command == 'exit'
      exit
    end
  end

  def start
    # only run this method if trivia is NOT already running
    unless running?
      self.running = true

      messenger.send_message('Starting')

      setup_question

      # Keep checking to see if the current question gets answered
      # so we can ask the next one
      scheduler.every '1s' do
        question_completed if current_question.answered?
      end
    end
  end

  def stop
    # only run this method if trivia is already running
    if running?
      messenger.send_message('Stopping')
      messenger.send_message(scores.round_scores, '`')

      # RESET EVERYTHING
      scores.merge_into_global
      self.current_question = nil
      self.running = false
      scheduler.jobs.each(&:unschedule)
    end
  end

  def skip(userid)
    if running?
      # User already voted, skip the rest of the function
      return if voter.vote(userid) == false

      if voter.passed?
        messenger.send_message('Vote passed. Skipping.')
        question_completed
      else
        messenger.send_message("#{voter.current_votes} vote(s) to skip. #{voter.threshold} needed.")
      end
    end
  end

  def exit
    stop if running?
    bot.stop
  end

  def question_completed
    timers.unschedule_all
    next_question
    setup_question
  end

  def setup_question
    current_question = pull_question
    p current_question.answer # TODO: Remove this

    # Ask the question
    messenger.send_message(current_question.question)

    timers.generate_question_timer
    timers.generate_hint_timer

    voter.reset
    voter.threshold = 2 # Temporary Hard Coding. Normally (scores.active_players / 3.0).floor

    # Create the answer trigger
    await_function = generate_await_function # (time_out, hint_timer)
    bot.add_await(content:        current_question.answer,
                  await_function: await_function)
  end

  def generate_await_function
    proc do |event|
      if running?
        messenger.send_message("Correct #{event.user.username}.")
        current_question.mark_answered

        scores.update(event.user, 1) # Hardcoded point value (1)
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

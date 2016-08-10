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
    #only run this method if trivia is NOT already running
    if not running?
      self.running = true
      messenger.send_message("Starting")

      setup_question

      scheduler.every '2s' do
        if current_question.answered?
          next_question
          setup_question
        end
      end

    end
  end

  def stop
    #only run this method if trivia is already running
    if running?
      messenger.send_message("Stopping")
      messenger.send_message(scores.get_round_scores)

      scores.clear
      self.current_question = nil

      self.running = false
      scheduler.jobs.each(&:unschedule)
    end
  end

  def setup_question
    question = get_question

    p question.answer

    #Ask the question
    messenger.send_message(question.question)

    #Question Timeout Timer
    timeout = scheduler.in '1m' do
      messenger.send_message("Times up! The answer was #{question.answer}")
      current_question.mark_answered
    end

    await_function = generate_await_function(timeout)

    bot.add_await({:content => current_question.answer, 
                   :await_function => await_function})
  end

  def generate_await_function(timeout)
    await_function = Proc.new do |event|
        if running?
          messenger.send_message("Correct #{event.user.username}.")
          current_question.mark_answered

          scores.update(event.user, 1) #Hardcoded point value (1)

          scheduler.unschedule(timeout)
        end
    end
  end

  def get_question
    #Generate question if none exists
    if current_question == nil then
      self.current_question = question_factory.new_question
    else
      current_question
    end
  end

  def next_question
    self.current_question = question_factory.new_question
  end

  def running?
    self.running ? true : false
  end
end

require_relative 'question_factory'

class Trivia
  attr_accessor :question_factory,
                :current_question,
                :running

  attr_reader   :messenger,
                :bot,
                :scheduler

  def initialize(trivia_bot, messenger)
    @question_factory = QuestionFactory.new
    @current_question = nil

    @bot              = trivia_bot
    @messenger        = messenger
    @running          = false
    @scheduler        = Rufus::Scheduler.new
  end

  def start
    #only run this method if trivia is NOT already running
    if not running?
      messenger.send_message("Starting")
      self.running = true

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
      self.running = false
      scheduler.shutdown
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
          messenger.send_message("Correct #{event.user.display_name}.")
          current_question.mark_answered
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

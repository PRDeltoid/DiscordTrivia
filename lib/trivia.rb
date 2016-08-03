require_relative 'question_factory'

class Trivia
  attr_accessor :question_factory, :current_question

  def initialize()
    @question_factory = QuestionFactory.new
    @current_question = nil
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

  def mark_answered
    current_question.mark_answered
  end

  def answered?
    return current_question.answered?
  end

end

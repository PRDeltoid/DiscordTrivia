require_relative 'question_factory'

class Trivia
  attr_accessor :question_factory, :current_question

  def initialize()
    @question_factory = QuestionFactory.new("")
    @current_question = nil
  end

  def get_question
    #Generate question if none exists
    if current_question == nil then
      current_question = question_factory.new_question
    else
      current_question
    end
  end

  def next_question
    current_question = question_factory.new_question
  end

end
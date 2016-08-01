require_relative 'question'
require_relative 'database'

class QuestionFactory
  attr_reader :api_endpoint, :database

  def initialize(api_endpoint)
    @api_endpoint
    @database = Database.new
  end

  def new_question
    question = database.random_row.first
    return Question.new(:question => question["question"], :answer=> question["answer"], :hints => generate_hints("Bar"))
  end

  #Temporary hardcoding of simple hints for above question.
  #This method will need to determine the amount of hints needed depending on the question's answer difficulty
  #Short answers do not need as many hints as long answers
  #Should have some sort of limit on possible hints to generate, to prevent small hints from being given rapidly
  def generate_hints(answer)
    ["B__", "B_r"]
  end

end

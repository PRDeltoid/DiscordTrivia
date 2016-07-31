require_relative 'question'

class QuestionFactory
  attr_reader :api_endpoint

  def initialize(api_endpoint)
    @api_endpoint
  end

  #Temporary hardcoding of a simple question (no api/database in use yet)
  def new_question
    Question.new(:question => "What is Foo?", :answer=> "Bar", :hints => generate_hints("Bar"))
  end

  #Temporary hardcoding of simple hints for above question.
  #This method will need to determine the amount of hints needed depending on the question's answer difficulty
  #Short answers do not need as many hints as long answers
  #Should have some sort of limit on possible hints to generate, to prevent small hints from being given rapidly
  def generate_hints(answer)
    ["B__", "B_r"]
  end

end

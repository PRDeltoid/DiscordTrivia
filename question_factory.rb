require_relative 'question'

class QuestionFactory
  attr_reader :api_endpoint

  def initialize(api_endpoint)
    @api_endpoint
  end

  def new_question
    Question.new(:question => "What is Foo?", :answer=> "Bar")
  end

end

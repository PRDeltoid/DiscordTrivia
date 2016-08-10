require_relative 'question'
require_relative 'question_database'
#require 'random'

class QuestionFactory
  attr_reader :database, :random

  def initialize
    @database = Question_Database.new
    self.database.connect
  end

  def new_question
    #Get a random number
    random_row = Random.rand(database.question_count)
    #Find row with id = to previous number
    question = database.select_row(random_row)

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

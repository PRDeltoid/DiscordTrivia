require_relative 'question'
require_relative 'question_database'
require_relative 'hint_factory'
# require 'random'

class QuestionFactory
  attr_reader :database, :random

  def initialize
    @database = QuestionDatabase.new
    database.connect
  end

  def new_question
    # Get a random number
    random_row = Random.rand(database.question_count)
    # Find row with id = to previous number
    question = database.select_row(random_row)

    # Remove all special characters
    question['question'] = question['question'].gsub(/[^0-9a-z\\-\\?\\! ]/i, '')
    question['answer'] = question['answer'].gsub(/[^0-9a-z\\-\\?\\! ]/i, '')

    # Generate hint array
    hints = HintFactory.generate_hints(question['answer'])

    Question.new(question: question['question'],
                 answer:   question['answer'],
                 hints:    hints['hints'],
                 hint_num: hints['hint_num'])
  end
end

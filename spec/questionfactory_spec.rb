require 'question_factory'

RSpec.describe QuestionFactory do
  #describe '#generate_hints' do
    #it 'should generate an array of hints based on input' do
      #expect(QuestionFactory.new.generate_hints('test')).to eq(['Foo B__', 'F_o B_r'])
    #end
  #end

  describe '#new_question' do
    it 'should not return a question with default values' do
      question = QuestionFactory.new.new_question
      expect(question.question).not_to eq('This is an example question')
      expect(question.answer).not_to eq('This is an example answer')
    end
  end
end

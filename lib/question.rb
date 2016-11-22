class Question
  attr_reader :question, :answer, :hint_num
  attr_accessor :answered, :hints

  def initialize(args)
    # Create defaults if no value exists
    args = defaults.merge(args)

    @question = args[:question]
    @answer   = args[:answer]
    @hints    = args[:hints]
    @hint_num = args[:hint_num]
    @answered = false
  end

  def defaults
    {
      question:  'This is an example question',
      answer:    'This is an example answer',
      hints:     ['Hint 1', 'Hint 2'],
      hint_num:  2
    }
  end

  def next_hint
    hints.shift
  end

  def hint
    return hints.first
  end

  def mark_answered
    self.answered = true
  end

  def answered?
    answered
  end
end

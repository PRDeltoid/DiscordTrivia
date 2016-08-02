class Question
  attr_reader :question, :answer
  attr_accessor :answered

  def initialize(args)
    #Create defaults if no value exists
    args = defaults.merge(args)

    @question = args[:question]
    @answer   = args[:answer]
    @hints    = args[:hints]
    @answered = false
  end

  def defaults
    {
     :question => "This is an example question",
     :answer   => "This is an example answer",
     :hints    => ["Hint 1", "Hint 2"]
    }
  end

  def next_hint
    self.hints.shift
  end

  def mark_answered
    self.answered = true
  end

  def answered?
    return answered
  end
end

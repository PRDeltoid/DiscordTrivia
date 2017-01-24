class Voter
  attr_reader   :current_voters
  attr_accessor :votes,
                :threshold

  def initialize(threshold = 1)
    @votes = 0
    @threshold = threshold
    @current_voters = []
  end

  def vote(userid)
    # User already voted guard clause
    return false if current_voters.include? userid

    current_voters.push(userid)
    self.votes += 1
    return true
  end

  def current_votes
    return votes
  end

  def passed?
    return false if votes < threshold
    return true
  end

  def reset
    self.votes = 0
    current_voters.clear
  end
end

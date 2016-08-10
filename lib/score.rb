class Score
  attr_accessor :name,
                :points,
                :id

  def initialize(name, id, points = 0)
    @name   = name
    @id     = id
    @points = points 
  end

  def increase_score(amount = 0)
    self.points += amount
  end
end


require 'discordrb'
require_relative 'score'

class Scores

  attr_accessor :current_scores

  def initialize
    @current_scores = []
  end

  def update(user, points)
    user_id = user.id
    username = user.username

    score_index = current_scores.index { |score|
      score.id == user_id
    }

    #User doesn't exist, add them to the score list
    if score_index == nil then
      current_scores.push(Score.new(username, user_id, points))
    else
    #User does exist, update their score
      current_scores[score_index].increase_score(points)
    end
  end

  def get_round_scores
    current_scores.each { |score|
      p "#{score.id} - #{score.name} - #{score.points}"
    }
  end

end

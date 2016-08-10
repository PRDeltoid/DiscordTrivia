require 'discordrb'
require_relative 'score'
require_relative 'score_database'

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
    score_text = ""
    current_scores.each { |score|
      score_text += "#{score.id} - #{score.name} - #{score.points}"
    }

    return score_text
  end

  def get_top_scores(scores_to_get)
    #TODO: Show top x scores
  end

  def merge_into_global
    #TODO: Merge round scores into global scores, then wipe Round scores (to be used after a round/match is over)
  end

  def clear
    self.current_scores = []
  end

end

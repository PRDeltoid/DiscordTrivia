require 'discordrb'
require_relative 'score'
require_relative 'score_database'

class Scores
  attr_accessor :current_scores, :score_db

  def initialize
    @current_scores = []
    @score_db = ScoreDatabase.new
    score_db.connect
  end

  def update(user, points)
    user_id = user.id
    username = user.username

    score_index = current_scores.index do |score|
      score.id == user_id
    end

    if score_index.nil?
      # User doesn't exist, add them to the score list
      current_scores.push(Score.new(username, user_id, points))
    else
      # User does exist, update their score
      current_scores[score_index].increase_score(points)
    end
  end

  def round_scores
    score_text = ''
    current_scores.each do |score|
      score_text += "#{score.id} - #{score.name} - #{score.points}\n"
    end

    return score_text
  end

  def top_scores(scores_to_get)
    # TODO: Show top x scores
  end

  def merge_into_global
    score_db.merge_scores(current_scores)
    clear
  end

  def clear
    self.current_scores = []
  end

  def active_players
    return current_scores.length
  end
end

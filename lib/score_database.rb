require_relative 'database'

class Score_Database < Database
  attr_accessor :score_table

  def initialize
    super()
    @score_table = $config.get('score_table')
  end

  def merge_scores(score_array)

    score_array.each do |score|
      #Find if a record already exists
      total_scores = client.query("SELECT TotalScore FROM #{score_table} WHERE UserID=#{score.id}")
      #p total_scores.count
      if total_scores.count > 0
        #Record found, update it
        update_score(score, total_scores.first["TotalScore"])
      else
        #No record, add a new score
        add_score(score)
      end
    end
  end

  def update_score(score, db_score)

    total_score = score.points + db_score 
    query_string = "UPDATE #{score_table}
                    SET TotalScore = #{total_score}
                    WHERE UserID = #{score.id}"
    #p query_string
    client.query(query_string)
  end

  def add_score(score)

    query_string = "INSERT INTO #{score_table} (UserID, TotalScore, LastScore)
                    VALUES (#{score.id}, #{score.points}, #{score.points})"
    #p query_string
    client.query(query_string)
  end

end


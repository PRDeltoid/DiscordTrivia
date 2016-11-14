require_relative 'database'

class QuestionDatabase < Database
  attr_accessor :question_table,
                :question_count

  def initialize
    super()
    @question_table = $config.get('question_table')
    @question_count = 0
  end

  def connect
    super()
    self.question_count = client.query("SELECT COUNT(*) AS question_count
                                        FROM #{question_table}").first['question_count']
  end

  def select_row(row_num)
    client.query("SELECT * FROM #{question_table} where id=#{row_num}").first
  end
end

require 'mysql2'

class Database
  attr_accessor :client, :question_count
  attr_reader :question_table

  def initialize()
    @client = nil
    @question_table = $config.get('question_table')
    @question_count = 0
  end

  def connected?
    !(client.nil?)
  end

  def connect
    self.client = Mysql2::Client.new(:host => 'localhost',
                                 :username => $config.get('username'),
                                 :password => $config.get('password'),
                                 :database => $config.get('database'))
    self.question_count = client.query("SELECT COUNT(*) AS question_count FROM #{question_table}").first["question_count"]
  end

  def select_row(row_num)
    return client.query("SELECT * FROM #{question_table} where id=#{row_num}").first
  end

end

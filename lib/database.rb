require 'mysql2'

class Database
  attr_accessor :client
  attr_reader :question_table, :question_count

  def initialize()
    @client = Mysql2::Client.new(:host => 'localhost',
                                 :username => $config.get('username'),
                                 :password => $config.get('password'),
                                 :database => $config.get('database'))
    @question_table = $config.get('question_table')
    @question_count = client.query("SELECT COUNT(*) AS question_count FROM #{question_table}").first["question_count"]
  end

  #hardcoded row
  def random_row
    return client.query("SELECT * FROM #{question_table} WHERE id=1")
  end
end

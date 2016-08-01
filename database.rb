require 'mysql2'

class Database 
  attr_accessor :client
  attr_reader :question_table

  def initialize()
    #TODO This is repeated from bot.rb, should be in it's own class
    json = File.read('config.json')
    config = JSON.parse(json)

    @client = Mysql2::Client.new(:host => 'localhost', 
                                 :username => config['username'],
                                 :password => config['password'], 
                                 :database => config['database'])
    @question_table = config['question_table']
  end

  #hardcoded row
  def random_row
    return client.query("SELECT * FROM #{question_table} WHERE id=1")
  end
end

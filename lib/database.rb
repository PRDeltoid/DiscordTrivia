require 'mysql2'

class Database
  attr_accessor :client

  def initialize()
    @client = nil
  end

  def connected?
    !(client.nil?)
  end

  def connect
    self.client = Mysql2::Client.new(:host => 'localhost',
                                 :username => $config.get('username'),
                                 :password => $config.get('password'),
                                 :database => $config.get('database'))
  end


end

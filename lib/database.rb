require 'mysql2'
require 'config'

class Database
  attr_accessor :client

  def initialize
    @client = nil
  end

  def connected?
    !client.nil?
  end

  def connect
    self.client = Mysql2::Client.new(host:     'localhost',
                                     username: Configuration.get('username'),
                                     password: Configuration.get('password'),
                                     database: Configuration.get('database'))
  end
end

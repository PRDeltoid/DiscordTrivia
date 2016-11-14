require 'json'

class Configuration
  attr_reader :config

  def initialize(path_to_config)
    json = File.read(path_to_config)
    @config = JSON.parse(json)
  end

  def get(attrib_key)
    config.fetch(attrib_key, nil)
  end
end

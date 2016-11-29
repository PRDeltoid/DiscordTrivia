require 'json'

module Configuration

  def self.get(attrib_key)
    json = File.read('config.json')
    @@config ||= JSON.parse(json)
    @@config.fetch(attrib_key, nil)
  end
end

class Logger
  TYPES = {
    test:     'test.txt',
    report:   'reports.txt',
    error:    'errors.txt',
    warn:     'warnings.txt'
  }.freeze

  def self.log(message, type)
    raise "No type #{type.id2name} found" unless TYPES.key?(type)

    log = File.open(TYPES[type], 'a')

    log.write("#{message}\n")
    log.close
  end
end

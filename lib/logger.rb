class Logger
  TYPES = {
    test:     "test.txt",
    report:   "reports.txt",
    error:    "errors.txt",
    warn:     "warnings.txt"
  }

  def self.log(message, type)
    if !TYPES.has_key?(type) then raise "No type with name #{type.id2name} found" end

    log = File.open(TYPES[type], 'a')

    log.write("#{message}\n")
    log.close
  end
end

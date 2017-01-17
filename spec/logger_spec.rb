require 'logger'

RSpec.describe Logger do
  describe '#log' do
    it 'should create a new file and write the message' do
      # Get rid of any old test logs
      if File.exist?('test.txt')
        File.delete('test.txt')
      end
      Logger.log('test', :test)

      expect(File.open('test.txt', 'r').read).to eq("test\n")
    end

    it 'should append to a file that already exists' do
      Logger.log('test', :test)

      expect(File.open('test.txt', 'r').read).to eq("test\ntest\n")

      # Clean up
      File.delete('test.txt')
    end

    it 'should raise an error when using a non-existant log type' do
      expect {Logger.log('test', :nothing)}.to raise_error(RuntimeError, "No type with name nothing found")
    end
  end
end

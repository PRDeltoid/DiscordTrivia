require 'database'

RSpec.describe Database do
  describe '#connected?' do
    it 'should return true if the database is connected' do
      database = Database.new
      database.connect
      expect(database.connected?).to eq(true)
    end
    it 'should return false if the database is NOT connected' do
      database = Database.new
      expect(database.connected?).to eq(false)
    end
  end
end

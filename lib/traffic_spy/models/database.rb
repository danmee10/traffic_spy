module TrafficSpy
  class TheDatabase
  # attr_accessor :database

    def self.database
      # @database ||= TrafficSpy::DB
      @database ||= Sequel.sqlite 'db/traffic_spy.sqlite3'
      #one line switch to postgres
    end
  end
end

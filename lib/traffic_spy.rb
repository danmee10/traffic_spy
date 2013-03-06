require 'sinatra/base'
require 'sequel'
require 'useragent'
require './lib/traffic_spy/models/base'

# require 'sqlite3'
# require 'traffic_spy/models/base'
# require 'traffic_spy/server'
# require 'traffic_spy/version'

module TrafficSpy
  module TheDatabase
  attr_accessor :database

    def self.database
      # @database ||= TrafficSpy::DB
      @database ||= Sequel.sqlite 'db/traffic_spy.sqlite3'
      #one line switch to postgres
    end
  end
end

# require 'sqlite3'
require 'sequel'

module TrafficSpy


  class Customer
    attr_reader :identifier, :root_url

    def initialize(input)
      @identifier = input[:identifier]
      @root_url = input[:root_url]
    end

    def self.database
      @database ||= Sequel.sqlite('./db/traffic_spy.sqlite3')
    end

    def save
      Customer.data.insert(:identifier => identifier,
                                            :root_url => root_url)
    end

    def self.data
      verify_table_exists
      database[:customers]
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def self.create_table
      database.create_table? :customers do
        primary_key :id
        String :identifier
        String :root_url
      end
    end

    def self.find_root_url(identifier)
      #takes in a customer's identifier and returns that customer's root url
      # dataset = database.from(:customers)
      # puts identifier
      data.select(:root_url).where(:identifier == identifier)
    end



  end
end

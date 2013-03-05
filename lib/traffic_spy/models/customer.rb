# require 'sqlite3'
require 'sequel'
require 'traffic_spy'

module TrafficSpy


  class Customer
    attr_reader :identifier, :rootUrl
    extend TheDatabase

    def initialize(input)
      @identifier = input[:identifier]
      @rootUrl = input[:rootUrl]
    end

    def save
      Customer.data.insert(:identifier => identifier,
                           :rootUrl => rootUrl)
    end

    def self.data
      verify_table_exists
      TheDatabase.database[:customers]
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

    def self.create_table
      Campaign.create_table
      Request.create_table
      TheDatabase.database.create_table? :customers do
        primary_key :id
        String      :identifier
        String      :rootUrl
      end
    end

    def self.find_root_url(identifier)
      row = data.select.where(:identifier => identifier)
      if row.to_a[-1] != nil
        row.to_a[-1][:rootUrl]
      end
    end

    def self.find_id(identifier)
      row = data.select.where(:identifier => identifier)
      if row.to_a[0] != nil
        row.to_a[0][:id]
      end
    end

#     def self.invalid_request!(message)
#   logger.info "Request rejected: #{message}\n#{caller(1).join "\n"}"
#   halt 400, message
# end

  end
end

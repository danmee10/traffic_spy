require 'sequel'
require 'traffic_spy'

module TrafficSpy

  class Request
    attr_reader :url,
                        :requestedAt,
                        :respondedIn,
                        :referredBy,
                        :requestType,
                        :parameters,
                        :eventName,
                        :userAgent,
                        :resolutionWidth,
                        :resolutionHeight,
                        :ip,
                        :customer_id

    def initialize(customer_id, data)
      # @id = data[:id]
      @url = data["url"]
      @requestedAt = data["requestedAt"]
      @respondedIn = data["respondedIn"]
      @referredBy = data["referredBy"]
      @requestType = data["requestType"]
      @parameters = data["parameters"]
      @eventName = data["eventName"]
      #@event_id = data[:event_id]
      @userAgent = data["userAgent"]
      @resolutionWidth = data["resolutionWidth"]
      @resolutionHeight = data["resolutionHeight"]
      @ip = data["ip"]
      @customer_id = customer_id
    end

    def self.create_table
      TheDatabase.database.create_table? :requests do
        primary_key :id
        foreign_key :customer_id
        foreign_key :event_id
        String :url
        Date :requestedAt
        Integer :respondedIn
        String :referredBy
        String :requestType
        String :parameters
        String :eventName
        String :userAgent
        Integer :resolutionHeight
        Integer :resolutionWidth
        String :ip
      end
    end

    def save
      Request.data.insert(:url => url,
                                        :requestedAt => requestedAt,
                                        :respondedIn => respondedIn,
                                        :referredBy => referredBy,
                                        :requestType => requestType,
                                        :parameters => parameters,
                                        :eventName => eventName,
                                        :userAgent => userAgent,
                                        :resolutionWidth => resolutionWidth,
                                        :resolutionHeight => resolutionHeight,
                                        :ip => ip,
                                        :customer_id => customer_id)
    end

    def self.data
      verify_table_exists
      TheDatabase.database[:requests]
    end

    def self.verify_table_exists
      @table_exists ||= (create_table || true)
    end

  end
end


# # require 'sqlite3'
#

# module TrafficSpy


#   class Customer
#     attr_reader :identifier, :root_url

#     def initialize(input)
#       @identifier = input[:identifier]
#       @root_url = input[:root_url]
#     end

#     def self.database
#       @database ||= Sequel.sqlite('./db/traffic_spy.sqlite3')
#     end

#     def save
#       Customer.data.insert(:identifier => identifier,
#                                             :root_url => root_url)
#     end

#     def self.data
#       verify_table_exists
#       database[:customers]
#     end

#     def self.verify_table_exists
#       @table_exists ||= (create_table || true)
#     end

#     def self.create_table
#       database.create_table? :customers do
#         primary_key :id
#         String :identifier
#         String :root_url
#       end
#     end

#     def self.find_root_url(identifier)
#       row = data.select.where(:identifier => identifier)
#       row.to_a[-1][:root_url]
#     end
#   end
# end

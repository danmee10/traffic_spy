require 'sinatra/base'
require 'sequel'
# require 'sqlite3'

require 'traffic_spy/models/base'
require 'traffic_spy/server'

require "traffic_spy/version"

# module TrafficSpy
#   # Your code goes here...
# end


# require 'traffic_spy/version'


module TrafficSpy

  # def self.database
  #   @database ||= Sequel.sqlite('./db/traffic_spy.sqlite3')
  # end

end

# TrafficSpy.database

# DB = Sequel.postgres "traffic_spy"


# DB.create_table? (:requests) do
#   primary_key :id
#   String :url
#   DateTime :requested_at
#   Integer :responded_in
#   String :referred_by
#   String :request_type
#   Array :parameters
#   # String :event_name
#   foreign_key :event_id
#   String :user_agent
#   String :resolution_width
#   String :resolution_height
#   String :ip_address
# end

# # Request.new url: "/test", responded_in:

# DB.create_table? (:urls) do
#   primary_key :id
# end

# DB.create_table? (:events) do
#   primary_key :id
# end

# DB.create_table? (:campaigns) do
#   primary_key :id
# end

# DB.create_table?(:campaign_events) do
#   primary_key :id
#   foreign_key :campaign_id
#   foreign_key :event_id
# end

# DB.create_table? (:identifiers) do
#   primary_key :id
#   String :root_url
# end


# results = DB.fetch "SELECT * from requests"
# puts "#{DB.schema(:identifier).class}"




# require 'traffic_spy/request'

#       lib/traffic_spy.rb

require 'sinatra/base'
require 'sequel'
# require 'sqlite3'

# require 'traffic_spy/models/base'
# require 'traffic_spy/server'

# require "traffic_spy/version"



# require 'traffic_spy/version'




# data = {"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700"}

# TrafficSpy.clean_payload_data(data)

# {"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}

module TheDatabase
attr_accessor :database

  def self.database
    @database ||= Sequel.sqlite('./db/traffic_spy.sqlite3')
  end

  def self.urls_by_times_requested(customer_id)
    all_urls = database[:requests].select(:url).where(:customer_id => customer_id)
    urls_array = all_urls.inject(Hash.new(0)) do |memo, url|
      memo[url[:url]] += 1
      memo
    end
    ordered_urls_array = urls_array.sort_by { |url, number| number }.reverse
  end

  def self.urls_by_response_time(customer_id)
    all_urls = database[:requests].select(:url,:respondedIn).where(:customer_id => customer_id).order(:respondedIn)
    url_count = all_urls.to_a.inject(Hash.new(0)) do |memo, row|
      memo[row[:url]] += 1.0
      memo
    end
    urls_hash = all_urls.inject(Hash.new(0)) do |memo, data|
      memo[data[:url]] += data[:respondedIn]
      memo
    end
    urls_w_avg_times = urls_hash.merge(url_count) {|url, total_response_time, times_requested| total_response_time/times_requested}
    urls_w_avg_times.sort_by { |url, avg_res_time| avg_res_time}
  end

  def self.screen_resolutions_by_times_requested(customer_id)
    all_width_x_height = database[:requests].select(:resolutionWidth,:resolutionHeight).where(:customer_id => customer_id)
    resolution_hash = all_width_x_height.inject(Hash.new(0)) do |memo, data|
      memo[data] += 1
      memo
    end
  end
end

example = TheDatabase.screen_resolutions_by_times_requested(6)
puts example



module TrafficSpy

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

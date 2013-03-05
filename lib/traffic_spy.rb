require 'sinatra/base'
require 'sequel'
require 'useragent'
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

  def self.url_extensions(customer_id)
    whole_urls = database[:requests].select(:url).where(:customer_id => customer_id)
    url_extensions = whole_urls.to_a.collect do |url|
      garbage = url[:url].sub!(/.*.com/, "")
    end
    url_extensions.uniq!
  end

  def self.url_specific_response_times(url)
    urls_and_response_times = database[:requests].select(:url,:respondedIn).where(:url => url)
    urls_and_response_times.to_a.sort_by { |url, response| response}
  end

  def self.events_by_times_received(customer_id)
    all_events = database[:requests].select(:eventName).where(:customer_id => customer_id)
    events_by_times_received = all_events.inject(Hash.new(0)) do |memo, event|
      memo[event[:eventName]] += 1
      memo
    end
    ordered_events_array = events_by_times_received.sort_by { |event, number| number }.reverse
  end

  def self.event_hourly_breakdown(eventName, customer_id)
    all_event_requests = database[:requests].select(:requestedAt).where(:customer_id => customer_id).where(:eventName => eventName)
    formated_times = all_event_requests.to_a.collect do |time|
      t = Time.parse(time[:requestedAt].to_s)
      t.strftime("%H")
    end
    event_requests_by_hour = formated_times.inject(Hash.new(0)) do |memo, hour|
      memo[hour] += 1
      memo
    end
  end

  def self.browser_breakdown(customer_id)
    user_agent_data = database[:requests].select(:userAgent).where(:customer_id => customer_id)
    parsed_user_agent_data = user_agent_data.to_a.collect do |data|
      parsed = UserAgent.parse(data[:userAgent])
      browser_data = parsed.browser
    end
    browser_hash = parsed_user_agent_data.inject(Hash.new(0)) do |memo, data|
      memo[data] += 1
      memo
    end
  end

  def self.operating_system_breakdown(customer_id)
    user_agent_data = database[:requests].select(:userAgent).where(:customer_id => customer_id)
    parsed_user_agent_data = user_agent_data.to_a.collect do |data|
      parsed = UserAgent.parse(data[:userAgent])
      browser_data = parsed.os
    end
    operating_system_hash = parsed_user_agent_data.inject(Hash.new(0)) do |memo, data|
      memo[data] += 1
      memo
    end
  end

  # def self.campaign_events_hash(customer_id, campaignName)
  #   all_events = database[:requests].select(:eventNames).where(:customer_id => customer_id).where(:campaignName => campaignName)
  #   events_by_times_received = all_events.inject(Hash.new(0)) do |memo, event|
  #     memo[event[:eventName]] += 1
  #     memo
  #   end
  #   # ordered_events_array = events_by_times_received.sort_by { |event, number| number }.reverse
  # end

  def self.identifier_exists?(customer_identifier)
    customer_identifiers = database[:customers].select(:identifier)
    customer_identifiers.to_a.any? { |identifier| identifier[:identifier] == customer_identifier}
  end

  # def self.payload_data_exists?(payload_data)
  #   customer_identifiers = database[:customers].select(:identifier)
  #   customer_identifiers.to_a.any? { |identifier| identifier[:identifier] == customer_identifier}
  # end

  def self.event_exists?(eventName)
    events = database[:requests].select(:eventName)
    events.to_a.any? { |event| event[:eventName] == eventName}
  end

  def self.screen_resolutions_by_times_requested(customer_id)
    all_width_x_height = database[:requests].select(:resolutionWidth,:resolutionHeight).where(:customer_id => customer_id)
    resolution_hash = all_width_x_height.inject(Hash.new(0)) do |memo, data|
      memo[data] += 1
      memo
    end
    resolution_hash.sort_by {|k| k[1]}.reverse
  end

end

# example = TheDatabase.screen_resolutions_by_times_requested(1)
# puts example


# # # example.to_a.each do |ex|
# #   puts ex[:url]
# end



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

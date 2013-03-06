require 'sequel'
require './lib/traffic_spy'

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
      TheDatabase.database[:requests]
    end
    ###############################

    def self.urls_by_times_requested(customer_id)
      all_urls = TheDatabase.database[:requests].select(:url).where(:customer_id => customer_id)
      urls_array = all_urls.inject(Hash.new(0)) do |memo, url|
        memo[url[:url]] += 1
        memo
      end
      ordered_urls_array = urls_array.sort_by { |url, number| number }.reverse
    end

    def self.urls_by_response_time(customer_id)
      all_urls = TheDatabase.database[:requests].select(:url,:respondedIn).where(:customer_id => customer_id).order(:respondedIn)
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
      whole_urls = TheDatabase.database[:requests].select(:url).where(:customer_id => customer_id)
      url_extensions = whole_urls.to_a.collect do |url|
        garbage = url[:url].sub!(/.*.com/, "")
      end
      url_extensions.uniq!
    end

    def self.url_specific_response_times(url)
      urls_and_response_times = TheDatabase.database[:requests].select(:url,:respondedIn).where(:url => url)
      urls_and_response_times.to_a.sort_by { |url, response| response}
    end

    def self.events_by_times_received(customer_id)
      all_events = TheDatabase.database[:requests].select(:eventName).where(:customer_id => customer_id)
      events_by_times_received = all_events.inject(Hash.new(0)) do |memo, event|
        memo[event[:eventName]] += 1
        memo
      end
      ordered_events_array = events_by_times_received.sort_by { |event, number| number }.reverse
    end

    def self.event_hourly_breakdown(eventName, customer_id)
      all_event_requests = TheDatabase.database[:requests].select(:requestedAt).where(:customer_id => customer_id).where(:eventName => eventName)
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
      user_agent_data = TheDatabase.database[:requests].select(:userAgent).where(:customer_id => customer_id)
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
      user_agent_data = TheDatabase.database[:requests].select(:userAgent).where(:customer_id => customer_id)
      parsed_user_agent_data = user_agent_data.to_a.collect do |data|
        parsed = UserAgent.parse(data[:userAgent])
        browser_data = parsed.os
      end
      operating_system_hash = parsed_user_agent_data.inject(Hash.new(0)) do |memo, data|
        memo[data] += 1
        memo
      end
    end

    def self.event_exists?(eventName)
      events = TheDatabase.database[:requests].select(:eventName)
      events.to_a.any? { |event| event[:eventName] == eventName}
    end


    def self.screen_resolutions_by_times_requested(customer_id)
      all_width_x_height = TheDatabase.database[:requests].select(:resolutionWidth,:resolutionHeight).where(:customer_id => customer_id)
      resolution_hash = all_width_x_height.inject(Hash.new(0)) do |memo, data|
        memo[data] += 1
        memo
      end
      resolution_hash.sort_by {|k| k[1]}.reverse
    end

    def self.url_exists?(input)
      all_urls = TheDatabase.database[:requests].select(:url)
      all_urls.to_a.any? { |url| url[:url] == input}
    end

    def self.payload_data_exists?(payload_data)
      if payload_data[:parameters] == []
        payload_params = nil
      else
        payload_params = payload_data[:parameters]
      end
      customer_identifiers = TheDatabase.database[:requests].where(:respondedIn => payload_data[:respondedIn]).where(:url => payload_data[:url]).where(:requestedAt => payload_data[:requestedAt]).where(:referredBy => payload_data[:referredBy]).where(:requestType => payload_data[:requestType]).where(:parameters => payload_params).where(:eventName => payload_data[:eventName]).where(:userAgent => payload_data[:userAgent]).where(:resolutionWidth => payload_data[:resolutionWidth]).where(:resolutionHeight => payload_data[:resolutionHeight]).where(:ip => payload_data[:ip])
      if customer_identifiers.to_a == []
        false
      else
        true
      end
    end
  end
end
# exists
# # curl -i -d 'payload={"url":"http://curlexample.com/party","requestedAt":"2013-02-16 01:38:28 -0700","respondedIn":99,"referredBy":"http://curlexample.com","requestType":"GET","parameters":[],"eventName": "heromode","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"4253","resolutionHeight":"2341","ip":"63.29.38.211"}' http://localhost:9393/sources/curl/data
# payload_data = {:respondedIn => "99", :url => "http://curlexample.com/party", :requestedAt =>"2013-02-16 01:38:28 -0700", :referredBy => "http://curlexample.com", :requestType => "GET", :parameters => [], :eventName => "heromode", :userAgent => "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", :resolutionWidth => "4253", :resolutionHeight => "2341", :ip => "63.29.38.4643"}
# example = TrafficSpy::Request.payload_data_exists?(payload_data)

#       if example.to_a == []
#         puts "false"
#       else
#         puts "true"
#       end



# # puts example.to_a



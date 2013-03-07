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
      @url              = data["url"]
      @requestedAt      = data["requestedAt"]
      @respondedIn      = data["respondedIn"]
      @referredBy       = data["referredBy"]
      @requestType      = data["requestType"]
      @parameters       = data["parameters"]
      @eventName        = data["eventName"]
      @userAgent        = data["userAgent"]
      @resolutionWidth  = data["resolutionWidth"]
      @resolutionHeight = data["resolutionHeight"]
      @ip               = data["ip"]
      @customer_id      = customer_id
      @clean_payload    = data
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
                          :customer_id => customer_id,
                          :payload_digest => Request.digest_payload(@clean_payload))
    end

    def self.digest_payload(clean_payload_hash)
      Digest::SHA1.hexdigest(clean_payload_hash.to_s)
    end

    def self.data
      TheDatabase.database[:requests]
    end

    def self.urls_by_times_requested(customer_id)
      all_urls = data.select(:url).where(:customer_id => customer_id)
      urls_array = all_urls.inject(Hash.new(0)) do |memo, url|
        memo[url[:url]] += 1
        memo
      end
      ordered_urls_array = urls_array.sort_by { |url, number| number }.reverse
    end

    def self.urls_by_response_time(customer_id)
      all_urls = data.select(:url,:respondedIn).where(:customer_id => customer_id).order(:respondedIn)
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
      whole_urls = data.select(:url).where(:customer_id => customer_id)
      url_extensions = whole_urls.to_a.collect do |url|
        garbage = url[:url].sub!(/.*.com/, "")
      end
      if url_extensions.count <= 1
        url_extensions
      else
        url_extensions.uniq!
      end
    end

    def self.url_specific_response_times(url)
      urls_and_response_times = data.select(:url,:respondedIn).where(:url => url)
      urls_and_response_times.to_a.sort_by { |url, response| response}
    end

    def self.events_by_times_received(customer_id)
      all_events = data.select(:eventName).where(:customer_id => customer_id)
      events_by_times_received = all_events.inject(Hash.new(0)) do |memo, event|
        memo[event[:eventName]] += 1
        memo
      end
      ordered_events_array = events_by_times_received.sort_by { |event, number| number }.reverse
    end

    def self.event_hourly_breakdown(eventName, customer_id)
      all_event_requests = data.select(:requestedAt).where(:customer_id => customer_id).where(:eventName => eventName)
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
      user_agent_data = data.select(:userAgent).where(:customer_id => customer_id)
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
    user_agent_data = data.select(:userAgent).where(:customer_id => customer_id)
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
      events = data.select(:eventName)
      events.to_a.any? { |event| event[:eventName] == eventName}
    end

    def self.screen_resolutions_by_times_requested(customer_id)
      all_width_x_height = data.select(:resolutionWidth,:resolutionHeight).where(:customer_id => customer_id)
      resolution_hash = all_width_x_height.inject(Hash.new(0)) do |memo, data|
        memo[data] += 1
        memo
      end
      resolution_hash.sort_by {|k| k[1]}.reverse
    end

    def self.url_exists?(input)
      all_urls = data.select(:url)
      all_urls.to_a.any? { |url| url[:url] == input}
    end

    def self.payload_data_exists?(payload_data)
      all_digests = data.select(:payload_digest)
      all_digests.to_a.any? { |d| d[:payload_digest] == digest_payload(payload_data.to_s)}
    end

    def self.count
      data.count
    end

    def self.destroy_all
      data.delete
    end
  end
end





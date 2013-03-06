require './lib/traffic_spy/models/customer'
require 'sinatra'
require 'JSON'
require './lib/traffic_spy'
require './lib/traffic_spy/models/request'
require 'useragent'
# require 'traffic_spy'

module TrafficSpy

  class Server #< Sinatra::Base
    set :views, 'lib/views'
    extend TheDatabase
    helpers do
      def blank?(key)
        params[key].nil? || params[key] == ""
      end
    end

    not_found do
      erb :error
    end

    get '/' do
      erb :register_customer
    end

    post '/sources' do
      if blank?(:identifier) || blank?(:rootUrl)
        halt 400, "ERROR: Identifier and RootUrl are required\n"
      elsif Customer.identifier_exists?(params[:identifier])
        halt 403, "ERROR: Identifier already exists!\n"
      else
        source_id = params[:identifier]
        root_url = params[:rootUrl]
        customer = Customer.new(:identifier => source_id,
                                :rootUrl => root_url)
        customer.save
        {identifier: customer.identifier}.to_json + "\n"
      end
    end

    get "/sources/:identifier" do
      @customer_identifier = params[:identifier]
      if Customer.identifier_exists?(@customer_identifier)
        @root_url = Customer.find_root_url(params[:identifier])
        customer_id = Customer.find_id(@customer_identifier)
        @urls_by_times_requested = Request.urls_by_times_requested(customer_id)
        @urls_by_response_time = Request.urls_by_response_time(customer_id)
        @resolutions_by_times_requested = Request.screen_resolutions_by_times_requested(customer_id)
        @web_browsers_by_times_requested = Request.browser_breakdown(customer_id)
        @operating_systems_by_times_requested = Request.operating_system_breakdown(customer_id)
        @url_extension_array = Request.url_extensions(customer_id)
        erb :customer_homepage
      else
        "Sorry, #{@customer_identifier} is not an identifier in our records"
      end
    end

    get "/sources/:identifier/urls/*" do
      @rootUrl = Customer.find_root_url(params[:identifier])
      @customer_identifier = params[:identifier]
      @path = params[:splat]
      @response_times = Request.url_specific_response_times("#{@rootUrl}/#{@path[0]}")
      if Request.url_exists?("#{@rootUrl}/#{@path[0]}")
        erb :url_data
      else
        "Url not on file.  Please enter valid url."
      end
    end

    get "/sources/:identifier/events" do
      @customer_identifier = params[:identifier]
      customer_id = Customer.find_id(@customer_identifier)
      @events_array = Request.events_by_times_received(customer_id)
      erb :aggr_event_data
    end

    get "/sources/:identifier/events/:event_name" do
      @eventName = params[:event_name]
      if Request.event_exists?(@eventName)
        @customer_identifier = params[:identifier]
        customer_id = Customer.find_id(@customer_identifier)
        @event_hourly_breakdown = Request.event_hourly_breakdown(@eventName, customer_id)
        erb :event_data
      else
        "Sorry, there is no event named #{@eventName} on file"
      end
    end

    get '/sources/:identifier/data' do
      if Customer.identifier_exists?(params[:identifier])
        @identifier = params[:identifier]
        erb :payload
      else
        "Sorry, #{@customer_identifier} is not an identifier in our records"
      end
    end

    post '/sources/:identifier/data' do |identifier|
      payload_data = params["payload"]
      unless payload_data == "" || payload_data == nil
        clean_payload_data = JSON.parse(payload_data)
      end
      if payload_data == nil
        halt 400, "ERROR: Please enter payload data\n"
      elsif payload_data == ''
        halt 400, "ERROR: Please enter payload data\n"
      elsif Request.payload_data_exists?(clean_payload_data)
        halt 403, "ERROR: Payload already received!\n"
      else

      customer_id = Customer.find_id(identifier)

      payload = Request.new(customer_id, clean_payload_data)

      payload.save

      "Payload Received!\n"
      end
    end
  end
end

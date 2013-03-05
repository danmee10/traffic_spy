require './lib/traffic_spy/models/customer'
require './lib/traffic_spy/models/campaign'
require 'sinatra'
require 'JSON'
# require 'traffic_spy'
require './lib/traffic_spy'
require './lib/traffic_spy/models/request'
require 'useragent'

  # Sinatra::Base - Middleware, Libraries, and Modular Apps
  #
  # Defining your app at the top-level works well for micro-apps but has
  # considerable drawbacks when building reusable components such as Rack
  # middleware, Rails metal, simple libraries with a server component, or even
  # Sinatra extensions. The top-level DSL pollutes the Object namespace and
  # assumes a micro-app style configuration (e.g., a single application file,
  # ./public and ./views directories, logging, exception detail page, etc.).
  # That's where Sinatra::Base comes into play:
module TrafficSpy


  class Server #< Sinatra::Base
    set :views, 'lib/views'
    extend TheDatabase

    get '/' do
      erb :register_customer
    end

    post '/sources' do
      Customer.create_table
      source_id = params[:identifier]
      root_url = params[:rootUrl]
      if params[:identifier] == nil || params[:identifier] == ""
        halt 400, "ERROR: Please enter an Identifier\n"
      elsif params[:rootUrl] == nil || params[:rootUrl] == ""
        halt 400, "ERROR: Please enter a RootUrl\n"
      elsif TheDatabase.identifier_exists?(params[:identifier])
        halt 403, "ERROR: Identifier already exists!\n"
      else
        #return status 200 and display {"identifier":"________"}
        customer = TrafficSpy::Customer.new(:identifier => source_id,
                                            :rootUrl => root_url)
        customer.save
        redirect to("/sources/#{source_id}")
      end
    end

    get "/sources/:identifier" do
      Customer.create_table
      @customer_identifier = params[:identifier]
      if TheDatabase.identifier_exists?(@customer_identifier)
        @root_url = TrafficSpy::Customer.find_root_url(params[:identifier])
        customer_id = Customer.find_id(@customer_identifier)
        @urls_by_times_requested = TheDatabase.urls_by_times_requested(customer_id)
        @urls_by_response_time = TheDatabase.urls_by_response_time(customer_id)
        @resolutions_by_times_requested = TheDatabase.screen_resolutions_by_times_requested(customer_id)
        @web_browsers_by_times_requested = TheDatabase.browser_breakdown(customer_id)
        @operating_systems_by_times_requested = TheDatabase.operating_system_breakdown(customer_id)
        @url_extension_array = TheDatabase.url_extensions(customer_id)
        erb :customer_homepage
      else
        "Sorry, #{@customer_identifier} is not an identifier in our records"
      end
    end

    get "/sources/:identifier/urls/:path" do
      @rootUrl = TrafficSpy::Customer.find_root_url(params[:identifier])
      @customer_identifier = params[:identifier]
      @path = params[:path]
      @response_times = TheDatabase.url_specific_response_times("#{@rootUrl}/#{@path}")
      erb :url_data
    end

    get "/sources/:identifier/urls/:path/:pathext1" do
      @rootUrl = TrafficSpy::Customer.find_root_url(params[:identifier])
      @customer_identifier = params[:identifier]
      @path = params[:path]
      @pathext1 = "/#{params[:pathext1]}"
      @response_times = TheDatabase.url_specific_response_times("#{@rootUrl}/#{@path}#{@pathext1}")
      erb :url_data
    end

    get "/sources/:identifier/urls/:path/:pathext1/:pathext2" do
      @rootUrl = TrafficSpy::Customer.find_root_url(params[:identifier])
      @customer_identifier = params[:identifier]
      @path = params[:path]
      @pathext1 = "/#{params[:pathext1]}"
      @pathext2 = "/#{params[:pathext2]}"
      @response_times = TheDatabase.url_specific_response_times("#{@rootUrl}/#{@path}#{@pathext1}#{@pathext2}")
      erb :url_data
    end

    get "/sources/:identifier/events" do
      @customer_identifier = params[:identifier]
      customer_id = Customer.find_id(@customer_identifier)
      @events_array = TheDatabase.events_by_times_received(customer_id)
      erb :aggr_event_data
    end

    get "/sources/:identifier/events/:event_name" do
      @eventName = params[:event_name]
      if TheDatabase.event_exists?(@eventName)
        @customer_identifier = params[:identifier]
        customer_id = Customer.find_id(@customer_identifier)
        @event_hourly_breakdown = TheDatabase.event_hourly_breakdown(@eventName, customer_id)
        erb :event_data
      else
        "Sorry, there is no event named #{@eventName} on file"
      end
    end

    get '/sources/:identifier/data' do
      if TheDatabase.identifier_exists?(params[:identifier])
        @identifier = params[:identifier]
        erb :payload
      else
        "Sorry, #{@customer_identifier} is not an identifier in our records"
      end
    end

    post '/sources/:identifier/data' do |identifier|
      # @identifier = params[:identifier]
      payload_data = params["payload"]
      unless payload_data == "" || payload_data == nil
        clean_payload_data = JSON.parse(payload_data)
      end
      if payload_data == nil
        halt 400, "ERROR: Please enter payload data\n"
      elsif payload_data == ''
        halt 400, "ERROR: Please enter payload data\n"
      # elsif TheDatabase.payload_data_exists?(clean_payload_data)
      #   halt 403, "ERROR: Payload already received!\n"
      else
      customer_id = Customer.find_id(identifier)

      payload = Request.new(customer_id, clean_payload_data)

      payload.save
      redirect to('/sources/whoeversubmitteditlast/data')
      end
    end

    not_found do
      erb :error
      # halt 400 if params.length == 0 -->should go @ end of post method
    end

    # post "/sources/:identifier/campaigns" do
    #   customer_identifier = params[:identifier]
    #   campaignName = params[:campaignName]
    #   eventNames = params[:eventNames]

    #   # event_array = Campaign.create_event_array(eventNames)


    #   customer_id = Customer.find_id(customer_identifier)
    #   campaign = TrafficSpy::Campaign.new(customer_id, campaignName, eventNames)
    #   campaign.save
    #   redirect to('/sources/fixlater/campaigns')
    # end

    # get "/sources/:identifier/campaign/:campaignName" do
    #   @customer_identifier = params[:identifier]
    #   @campaignName = params[:campaignName]

    #   # @campaign_events_by_times_received


    #   erb :campaign_data
    # end





  end
end


##############
##frank
############
    # get '/' do
    #   erb :index
    # end

    # get "/sources/:id" do
    #   source_id = params[:id]
    #   " Hello #{source_id}"
    # end


    # get "/sources/:id/events" do
    #  source_id = params[:id]
    #   " Hello #{source_id} these are your events"
    #   # erb :events
    # end


    # get "/sources/:id/events/:event_id" do
    #  source_id = params[:id]
    #   " Hello #{source_id} here is your event #{params[:event_id]}"
    # end

    # get "/sources/:id/campaigns/:campaign_id" do
    #   source_id = params[:id]
    #   " Hello #{source_id} here is your campaign #{params[:campaign_id]}"
    # end

    # not_found do
    #   erb :error
    # end

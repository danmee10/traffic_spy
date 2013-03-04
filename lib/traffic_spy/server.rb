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
  #
module TrafficSpy


  class Server #< Sinatra::Base
    set :views, 'lib/views'
    extend TheDatabase

    get '/' do
      erb :register_customer
    end

    post '/sources' do
      source_id = params[:identifier]
      root_url = params[:rootUrl]
      # if source_id || root_url == nil
      #   redirect to(not_found)
      #   @code = "400"
      # end
      customer = TrafficSpy::Customer.new(:identifier => source_id,
                                                                        :rootUrl => root_url)

      customer.save

      redirect to("/sources/#{source_id}")
    end

    get "/sources/:identifier" do
      @customer_identifier = params[:identifier]
      @root_url = TrafficSpy::Customer.find_root_url(params[:identifier])
      customer_id = Customer.find_id(@customer_identifier)

      @urls_by_times_requested = TheDatabase.urls_by_times_requested(customer_id)
      @urls_by_response_time = TheDatabase.urls_by_response_time(customer_id)
      @resolutions_by_times_requested = TheDatabase.screen_resolutions_by_times_requested(customer_id)
      @web_browsers_by_times_requested = TheDatabase.browser_breakdown(customer_id)
      @operating_systems_by_times_requested = TheDatabase.operating_system_breakdown(customer_id)

      @url_extension_array = TheDatabase.url_extensions(customer_id)


      erb :customer_homepage
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
      @customer_identifier = params[:identifier]
      customer_id = Customer.find_id(@customer_identifier)
      @eventName = params[:event_name]
      @event_hourly_breakdown = TheDatabase.event_hourly_breakdown(@eventName, customer_id)
      erb :event_data
    end

    get '/sources/:identifier/data' do
      @identifier = params[:identifier]
      erb :payload
    end

    post '/sources/:identifier/data' do |identifier|
      # @identifier = params[:identifier]
      payload_data = params["payload"]

      clean_payload_data = JSON.parse(payload_data)

      customer_id = Customer.find_id(identifier)

      payload = Request.new(customer_id, clean_payload_data)

      payload.save
      redirect to('/sources/whoeversubmitteditlast/data')
    end




    get '/sources/:identifier/campaign' do
      erb :register_campaign
    end

    post "/sources/:identifier/campaign" do
      campaign_name = params[:campaign_name]
      event_names = params[:event_names]
      TrafficSpy::Campaign.new(campaign_name, event_names)
    end

    get "/sources/:identifier/campaign/:campaign_name" do
      erb :campaign_data
    end

    not_found do
      erb :error

      # halt 400 if params.length == 0 -->should go @ end of post method
    end



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

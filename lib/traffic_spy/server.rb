require 'sinatra'
module TrafficSpy

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
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    get "/sources/:id" do
      source_id = params[:id]
      " Hello #{source_id}"
    end


    get "/sources/:id/events" do
     source_id = params[:id]
      " Hello #{source_id} these are your events"
      # erb :events
    end


    get "/sources/:id/events/:event_id" do
     source_id = params[:id]
      " Hello #{source_id} here is your event #{params[:event_id]}"
    end

    get "/sources/:id/campaigns/:campaign_id" do
      source_id = params[:id]
      " Hello #{source_id} here is your campaign #{params[:campaign_id]}"
    end

    not_found do
      erb :error
    end
  end

end

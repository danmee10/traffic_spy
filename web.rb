require 'sinatra'

class Application

end

# post '/sources' do
#     #
#   identifier = params[:identifier]
#   root_url = params[:rootUrl]

#   application = Application.new
#   application.identifer = identifier
#   application.root_url = root_url

#   # # does this application exist already
#   # if application.exists?
#   #   #403 forbidden
#   # elsif
#   #   application.save
#   #   # return a success status 200
#   # elsif #not enough parameters
#   #   #400 bad request
#   # end

# end

# post 'sources/IDENTIFIER/data'
#   #extract payload data
#   #analyse payload data
#   #store payload data

#   #or error message
# end

# get 'sources/IDENTIFIER'
# # Most requested URLS to least requested URLS (url)
# # Web browser breakdown across all requests (userAgent)
# # OS breakdown across all requests (userAgent)
# # Screen Resolution across all requests (resolutionWidth x resolutionHeight)
# # Longest, average response time per URL to shortest, average response time per URL
# # Hyperlinks of each url to view url specific data
# # Hyperlink to view aggregate event data

# #if no identifier, puts identifier does not exist
# end

# get 'sources/IDENTIFIER/urls/RELATIVE/PATH'
#   #list response times for individual url from longest to shortest

#   #or error message ""
# end

# get 'sources/IDENTIFIER/events'
#   #list all events from most received to least received
#   #links to individual events

#   #if no event return error, no  events defined
# end

# get 'sources/IDENTIFIER/events/EVENTNAME'
#   #hour by hour breakdown of when event was received

#   #if no event has been defined, then return error no event defineed
#   #link to app events index
# end

# post 'sources/IDENTIFIER/campaign'
#   #register campaign
#   # campaignName = params[:campaignName]
#   # eventName = params[:eventName]
# end

# get 'sources/IDENTIFIER/campaign'
#   #links to campaigns to view specific data
#   #
#   #if none defined..error message
# end

# get 'sources/IDENTIFIER/campaigns/CAMPAIGNNAME'
#   #campaign specific data
#     #most reveived event to least
#     #links to specific events

#     #if no campaign..error message
# end
set :views, 'lib/views'
require './lib/traffic_spy/models/customer'
require './lib/traffic_spy/models/campaign'
# Bundler.require

get '/' do
  erb :register_customer
end

post '/sources' do
  # puts "#{Time.now} got response #{params}"
  source_id = params[:identifier]
  root_url = params[:root_url]
  # if source_id || root_url == nil
  #   redirect to('/error400')
  # end
  customer = TrafficSpy::Customer.new(:identifier => source_id,
                                                                    :root_url => root_url)
  #store all customer information as a unique instance of a customer
  customer.save

  redirect to("/sources/#{source_id}")
end

get "/sources/:identifier" do
  @customer_id = params[:identifier]
  @root_url = TrafficSpy::Customer.find_root_url(:identifier)
  erb :customer_homepage
end

post '/sources/:identifier/data' do
  payload = Request.new(data)
end


get '/sources/:identifier/url' do
  erb :url_data
end

get "/sources/:identifier/events" do
  erb :aggr_event_data
end

get "/sources/:identifier/events/:event_name" do
  erb :event_data
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

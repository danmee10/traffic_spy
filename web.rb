curl -i -d 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'  http://localhost:9393/sources/dan/data



'payload={"url":"http://bigexample.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
# require 'sinatra'

# class Application

# end
{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700"}

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


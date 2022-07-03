require 'sinatra'
require 'api/result.rb'

# show html page
get '/' do
    'Hello world!'
end

# get JSON data from API /result/?type=jsonfile
get '/result/:type' do
    result = GetResult.new
    result.get("#{params['type']}")
end
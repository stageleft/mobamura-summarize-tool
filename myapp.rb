require 'sinatra'
require_relative './api/result'

# show html page
get '/' do
    erb :index
end

# get JSON data from API /result/?type=jsonfile
get '/result/:type' do
    result = GetResult.new
    result.get("#{params['type']}")
end
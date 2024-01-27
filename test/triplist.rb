require_relative "#{__dir__}/../api/get_player_trip"
require'json'

if ARGV.size != 0 then
    puts "usage : ruby triplist.rb"
    return
end

mjlinstance = GetTripList.new

table_A = mjlinstance.parseResultQueryByTrip(mjlinstance.query())
table_B = mjlinstance.getFromFile("#{__dir__}/../data/triplist.json")

puts __dir__
puts JSON.pretty_generate(table_A)
puts
puts JSON.pretty_generate(table_B)
puts
puts JSON.pretty_generate(table_B.merge(table_A))

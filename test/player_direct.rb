require_relative "#{__dir__}/../api/get_player_list"
require "json"

if ARGV.size < 1 then
    puts "usage : ruby player_direct.rb character_name [character_name...]"
    return
end

mjlinstance = GetPlayerList.new
raw_result = mjlinstance.queryByCn(ARGV)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}
puts raw_result

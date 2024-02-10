require_relative "#{__dir__}/../api/get_player_list"
require "json"

if ARGV.size != 2 then
    puts "usage : ruby player_direct_parse.rb single_parse_result.json character_name"
    return
end

mjlinstance = GetPlayerList.new

File.open(ARGV[0]){|f|

    rawdata = f.readlines
    jsondata = rawdata.join('')
    raw_result = mjlinstance.parseResultQueryByCn(jsondata, ARGV[1])  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}

    puts JSON.generate(raw_result)
}
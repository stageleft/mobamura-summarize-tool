require_relative "#{__dir__}/../api/get_player_list"
require "json"

if ARGV.size != 1 then
    puts "usage : ruby playerlist.rb single_parse_result.json"
    return
end

mjlinstance = GetPlayerList.new

File.open(ARGV[0]){|f|

    rawdata = f.readlines
    jsondata = rawdata.join('')
    raw_result = mjlinstance.parseResultQueryByCn(jsondata)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}

    puts JSON.generate(raw_result)
}
require_relative "#{__dir__}/../api/get_player_list"
require "json"

if ARGV.size != 1 && ARGV.size != 2 then
    puts "usage : ruby playerlist.rb [character_list.json]"
    return
elsif ARGV.size == 2 then
    outfile = ARGV[1]
end

mjlinstance = GetPlayerList.new

File.open(ARGV[0]){|f|

    rawdata = f.readlines
    jsondata = rawdata.join('')
    raw_result = mjlinstance.queryByJson(jsondata)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}

    puts JSON.pretty_generate(raw_result)
}
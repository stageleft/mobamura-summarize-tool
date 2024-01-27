require_relative "#{__dir__}/../api/get_player_list"
require_relative "#{__dir__}/../api/calc_play_count"

require 'csv'

outfile = "output.csv"
if ARGV.size != 1 && ARGV.size != 2 then
    puts "usage : ruby index.rb [character_list.json] [output.csv]"
    return
elsif ARGV.size == 2 then
    outfile = ARGV[1]
end


mjlinstance = GetPlayerList.new
mjlcounter  = CalcPlayCount.new

File.open(ARGV[0]){|f|
    rawdata = f.readlines
    jsondata = rawdata.join('')
    raw_result = mjlinstance.queryByJson(jsondata)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}

    result = mjlcounter.count_play(jsondata, mjlcounter.set_player_name(raw_result))

    listed_result = mjlcounter.sort_and_add_rank(result);
    CSV.open(outfile, 'w', :force_quotes => true) {|o|
        o << ["cn", "player", "play_count", "count_rank"]
        listed_result.each {|data|
            o << [data[:cn],data[:player],data[:count],data[:rank]]
        }
    }
}

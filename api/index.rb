require_relative './get_player_list'
require_relative './calc_play_count'

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

    CSV.open(outfile, 'w', :force_quotes => true) {|o|
        o << ["cn", "player", "play_count"]
        result.each_key {|cn|
            result[cn].each_key{|player|
                o << [cn, player, result[cn][player]]
            }
        }
    }
}

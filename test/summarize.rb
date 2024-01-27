require_relative "#{__dir__}/../api/calc_play_count"

require 'csv'

outfile = "output.csv"
if ARGV.size != 3 && ARGV.size != 4 then
    puts "usage : ruby summarize.rb trip_list.json character_list.json query_result.json [output.csv]"
    return
elsif ARGV.size == 4 then
    outfile = ARGV[3]
end

mjlcounter  = CalcPlayCount.new

File.open(ARGV[0]){|f0|
    trip_list = f0.readlines.join('')
    File.open(ARGV[1]){|f1|
        character_list = f1.readlines.join('')
        File.open(ARGV[2]){|f2|
            query_result = f2.readlines.join('')

            t = JSON.parse(trip_list)
            q = JSON.parse(query_result)

            players = mjlcounter.set_player_name(q, t)
            result = mjlcounter.count_play(character_list, players)

            listed_result = mjlcounter.sort_and_add_rank(result);
            CSV.open(outfile, 'w', :force_quotes => true) {|o|
                o << ["cn", "player", "play_count", "count_rank"]
                listed_result.each {|data|
                    o << [data[:cn],data[:player],data[:count],data[:rank]]
                }
            }   
        }
    }
}

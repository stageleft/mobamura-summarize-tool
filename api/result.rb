require 'json'
require_relative './get_player_list'
require_relative './calc_play_count'

class GetResult
    def initialize
    end
    # Filename -> 
    def get(list_json)
        mjlinstance = GetPlayerList.new
        mjlcounter  = CalcPlayCount.new
        
        tabledata = []
        File.open(list_json){|f|
            rawdata = f.readlines
            jsondata = rawdata.join('')
            raw_result = mjlinstance.queryByJson(jsondata)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}
        
            result = mjlcounter.count_play(jsondata, mjlcounter.set_player_name(raw_result))

            result.each_key {|cn|
                result[cn].each_key{|player|
                    tabledata.push({"cn":cn, "player":player, "count":result[cn][player]})
                }
            }
        }

        JSON.generate(tabledata)
    end
end


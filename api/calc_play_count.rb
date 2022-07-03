require 'json'

class CalcPlayCount
    def initialize
    end
    def set_player_name(queryresult)
        ret_value = {}

        queryresult.each_key{|k|
            ret_value[k] = []
            queryresult[k].each{|l|
                if l["HN"] == "-" then
                    ret_value[k].push(l["trip"])
                else
                    ret_value[k].push(l["HN"])
                end
            }
        }

        ret_value
    end
    def count_play(cnlist, queryresult)
        ret_value = {} # ret_value.character.player: int

        l = JSON.parse(cnlist)
        if (l["characteres"] != nil) then
            l["characteres"].each{|e|
                if ret_value[e] == nil then
                    ret_value[e] = {}
                end
                queryresult[e].each{|f|
                    if ret_value[e][f] == nil then
                        ret_value[e][f] = 1
                    else
                        ret_value[e][f] = ret_value[e][f] + 1
                    end
                }
            };
        end
        if (l["alias"] != nil) then
            l["alias"].each{|e|
                if ret_value[e["link"]] == nil then
                    ret_value[e["link"]] = {}
                end
                queryresult[e["cn"]].each{|f|
                    if ret_value[e["link"]][f] == nil then
                        ret_value[e["link"]][f] = 1
                    else
                        ret_value[e["link"]][f] = ret_value[e["link"]][f] + 1
                    end
                }
            };
        end

        ret_value
    end
end
require 'uri'
require 'net/http'
require 'json'

class GetPlayerList
    def initialize
        @baseuri = "http://mobajinro.s178.xrea.com/mobajinrolog/api/searchLog.php" # 戦績API
    end
    # Array[String] -> (web access) -> JSON
    def queryByCn(character_names)
        query_param = []
        character_names.each do |cn|
            query_param.push ["cn[]", cn]
        end
        query_param.push ["reverse", "0"]
        query_param.push ["operator", "OR"]
        uri   = URI("#{@baseuri}?#{URI.encode_www_form(query_param)}")
        res = Net::HTTP.get_response(uri)

        res.body if res.is_a?(Net::HTTPSuccess)
    end
    # HTML -> Array of Hash
    def parseResultQueryByCn(body_string)
        result = [] # [{"HN":hn, "TRIP":trip},...]

        body = JSON.parse(body_string)["data"]
        body.each{|a|
            data = {}
            data["HN"] = a["hn"]
            data["trip"] = a["trip"]
            result.push(data)
        }

        result
    end
    # Hash -> Hash
    def queryByJson(cnlist)
        ret_value = {};

        l = JSON.parse(cnlist)
        if (l["characteres"] != nil) then
            l["characteres"].each{|e|
                ret_value[e] = parseResultQueryByCn(queryByCn([e]))
            };
        end
        if (l["alias"] != nil) then
            l["alias"].each{|e|
                ret_value[e["cn"]] = parseResultQueryByCn(queryByCn([e["cn"]]));
            };
        end

        ret_value
    end
end
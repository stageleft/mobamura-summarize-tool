require 'uri'
require 'net/http'
require 'json'

class GetPlayerList
    def initialize
        # @baseuri = "http://mobajinro.s178.xrea.com/mobajinrolog/result.php" # 現行戦績ツール
        @baseuri = "http://mobajinro.s178.xrea.com/mobajinrolog/api/searchLog.php" # 戦績API
    end
    # String -> (web access) -> JSON
    def queryByCn(character_name)
        param = URI.encode_www_form({"cn[]":character_name, reverse:"0", operator:"OR"});
        uri   = URI("#{@baseuri}?#{param}")
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
                ret_value[e] = parseResultQueryByCn(queryByCn(e))
            };
        end
        if (l["alias"] != nil) then
            l["alias"].each{|e|
                ret_value[e["cn"]] = parseResultQueryByCn(queryByCn(e["cn"]));
            };
        end

        ret_value
    end
end
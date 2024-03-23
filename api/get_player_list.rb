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
        uri = URI("#{@baseuri}?#{URI.encode_www_form(query_param)}")
        res = Net::HTTP.get_response(uri)

        res.body if res.is_a?(Net::HTTPSuccess)
    end
    # HTML -> Array of Hash
    def parseResultQueryByCn(body_string, character_name)
        result = [] # [{"HN":hn, "TRIP":trip},...]

        body = JSON.parse(body_string)["data"]
        body.each do |a|
            if a["cn"].strip == character_name then
                data = {}
                data["HN"] = a["hn"]
                data["trip"] = a["trip"]
                result.push data
            end
        end

        result
    end
    # Array -> Hash
    def queryByCnList(cnlist_array)
        ret_value = {};

        if (cnlist_array != nil) then
            character_data = queryByCn(cnlist_array)
            cnlist_array.each do |e|
                ret_value[e] = parseResultQueryByCn(character_data, e)
            end
        end

        ret_value
    end
    # Hash -> Hash
    def queryByJson(cnlist)
        cnlist_array = [];

        l = JSON.parse(cnlist)
        l["characteres"].each do |e|
            cnlist_array.push e
        end
        l["alias"].each do |e|
            cnlist_array.push e["cn"]
        end

        queryByCnList(cnlist_array)
    end
end
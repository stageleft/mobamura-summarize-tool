require 'uri'
require 'net/http'
require 'nokogiri'
require 'json'

class GetPlayerList
    def initialize
        @baseuri  = "http://mobajinro.s178.xrea.com/mobajinrolog/result.php"
    end
    # String -> (web access) -> HTML
    def queryByCn(character_name)
        param = URI.encode_www_form({query:"cn:"+character_name, reverse:"on", operator:"OR"});
        uri   = URI("#{@baseuri}?#{param}")
        res = Net::HTTP.get_response(uri)

        res.body if res.is_a?(Net::HTTPSuccess)
    end
    # HTML -> Array of Hash
    def parseResultQueryByCn(body_string)
        result = [] # [{"HN":hn, "TRIP":trip},...]

        # get table, which has id='resulttable'
        doc = Nokogiri::HTML(body_string)
        table = doc.xpath("//*[@id='resulttable']")
        table.xpath("./tr[@id!='']").each{|tr|
            data = {}
            # data["CN"] = tr.xpath("./td[@class='td_3']").text
            data["HN"] = tr.xpath("./td[@class='td_4']").text
            data["trip"] = tr.xpath("./td[@class='td_5']").text
            result.push(data)
        }

        result
    end
    # Hash -> Hash
    def queryByJson(cnlist)
        ret_value = {};

        l = JSON.parse(cnlist)
        l["characteres"].each{|e|
            ret_value[e] = parseResultQueryByCn(queryByCn(e))
        };
        l["alias"].each{|e|
            ret_value[e["cn"]] = parseResultQueryByCn(queryByCn(e["cn"]));
        };

        ret_value
    end
end
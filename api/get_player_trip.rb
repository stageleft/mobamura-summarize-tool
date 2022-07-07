require 'uri'
require 'net/http'
require 'nokogiri'
require 'json'

class GetTripList
    def initialize
        # @baseuri  = "http://mobajinro.s178.xrea.com/mobajinrolog/player/index.html"
        @baseuri  = "http://mobajinro.s178.xrea.com//mobajinrolog/api/getPlayer.php"
    end
    # String -> (web access) -> HTML
    def query()
        uri   = URI("#{@baseuri}")
        res = Net::HTTP.get_response(uri)

        res.body if res.is_a?(Net::HTTPSuccess)
    end
    # HTML -> Array of Hash
    def parseResultQueryByTrip(body_json) # input : [{name:"name", trips:"◆,◆,..."}`}]
        body_hash = eval(body_json)
        ret_hash = {}

        body_hash.each{|pair|
            pair_name = pair[:name];
            pair_trip = pair[:trips].split(",");
            pair_trip.each{|trip|
                ret_hash[trip] = pair_name
            }
        }

        ret_hash
    end
    def getFromFile(list_json)
        begin
            File.open(list_json){|f|
                return eval(f.readlines.join(''))
            }
        rescue => e
            puts e
        ensure
            return {}
        end
    end
end
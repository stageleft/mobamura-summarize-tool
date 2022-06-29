require './get_player_list'

if ARGV.size != 1 then
    puts "usage : ruby index.rb [character_list.json]"
    return
end

mjlinstance = GetPlayerList.new
File.open(ARGV[0]){|f|
    rawdata = f.readlines
    jsondata = rawdata.join('')
    raw_result = mjlinstance.queryByJson(jsondata)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}

    puts raw_result # debug
    # TODO: calc raw_result and get 
}

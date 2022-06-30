require './get_player_list'
require './calc_play_count'

if ARGV.size != 1 then
    puts "usage : ruby index.rb [character_list.json]"
    return
end

mjlinstance = GetPlayerList.new
mjlcounter  = CalcPlayCount.new

File.open(ARGV[0]){|f|
    rawdata = f.readlines
    jsondata = rawdata.join('')
    raw_result = mjlinstance.queryByJson(jsondata)  # hash result of {CN=>[{hn=>hn, trip=>trip},...], CN=>...}

    calced_result = mjlcounter.count_play(jsondata, mjlcounter.set_player_name(raw_result))

    puts calced_result # debug
    # TODO: calc raw_result and get 
}

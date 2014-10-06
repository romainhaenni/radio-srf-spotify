class SoundsController < ApplicationController
  
  def scan
    srf_channel = 'dd0fa1ba-4ff6-4e1a-ab74-d7e49057d96f'
    songlog = JSON.load(open("http://ws.srf.ch/songlog/log/channel/#{srf_channel}/playing.json"))
    puts "songlog: #{songlog}"
    @title = songlog['Songlog'][0]['Song']['title']
    @artist = songlog['Songlog'][0]['Song']['Artist']['name']
    
    create_user_playlist('116870260')
  end
end

# {
#   "pageNumber":1,
#   "pageSize":1,
#   "totalPages":1,
#   "totalElements":1,
#   "Songlog":[
#     {
#       "id":"0a0b812e-77ab-4be1-989e-179b37576b73",
#       "channelId":"dd0fa1ba-4ff6-4e1a-ab74-d7e49057d96f",
#       "playedDate":"2014-10-06T21:08:40+02:00",
#       "isPlaying":true,
#       "Song":{
#         "title":"A Whiter Shade of Pale",
#         "Artist":{
#           "name":"Procol Harum",
#           "id":"6aa20c94-7844-4865-b1d6-b0491361a448",
#           "modifiedDate":"2013-02-17T10:57:08+01:00",
#           "createdDate":"2009-01-02T04:52:54+01:00"
#         },
#         "id":"b8a1a891-43f2-47ab-94db-75633fea4ff9",
#         "modifiedDate":"2013-03-02T19:32:28+01:00",
#         "createdDate":"2009-01-02T04:52:54+01:00"
#       }
#     }
#   ]
# }
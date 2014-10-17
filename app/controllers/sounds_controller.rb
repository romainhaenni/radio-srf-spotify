class SoundsController < ApplicationController
  
  def scan
    spotify(songlog)
    respond_to do |format|
      format.html
    end
  end
  
  def export
    new_track = RSpotify::Track.find(spotify(songlog))
    if new_track
      User.each do |u|
        if u.activated and u.schedule.occurring_at?(Time.now)
          RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
          # Get Spotify user
          spotify_user = RSpotify::User.new(u.spotify_hash)
          # Get playlist
          if u.spotify_playlist_id.nil? or u.spotify_playlist_id.empty?
            playlist_name = 'Radio SRF 3 @Spotify'
            spotify_playlist = spotify_user.create_playlist!(playlist_name)
            u.update_attribute :spotify_playlist_id, spotify_playlist.id
          else
            spotify_playlist = RSpotify::Playlist.find u.spotify_id, u.spotify_playlist_id
          end
          # Add track to playlist
          spotify_playlist.add_tracks!([new_track], position: 0) if spotify_playlist.tracks.empty? or not spotify_playlist.tracks.first.id == new_track.id
          u.update_attribute :spotify_hash, spotify_user.to_hash
        end
      end
    end
    
    render nothing: true
  end
  
  private
  
  def songlog
    playing = JSON.load(open("http://ws.srf.ch/songlog/log/channel/#{Global.channels.srf_3}/playing.json"))
    
    track = nil
    if playing['totalElements'] > 0
      @title = playing['Songlog'][0]['Song']['title']
      @artist = playing['Songlog'][0]['Song']['Artist']['name']
      track = {artist: @artist, title: @title}
    end
    track
  end
  
  # options
  #   artist: name of the artist
  #   title: title of the track by the same artist
  def spotify options
    if options
      search_query = "track:#{CGI::escape options[:title]}+artist:#{CGI::escape options[:artist]}"
      result_set = JSON.load(open("#{Global.spotify.api_url}/search?q=#{search_query}&type=track&market=CH&limit=1"))

      if result_set['tracks']['total'].to_i > 0
        @track_id = result_set['tracks']['items'][0]['id']
      end
    end
    @track_id
  end
end
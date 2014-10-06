class UsersController < ApplicationController
  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    puts "spotify user: #{spotify_user.to_hash}"
    
    redirect_to root_path
  end
end
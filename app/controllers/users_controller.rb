class UsersController < ApplicationController
  def edit
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @user = User.find_by(spotify_id: spotify_user.id) || User.create(name: spotify_user.display_name, spotify_id: spotify_user.id)
    @user.update_attribute :spotify_hash, spotify_user.to_hash
  end
  
  def update
    @user = User.find_by params[:user][:id]
    respond_to do |format|
      if @user.update_attributes user_params
        flash[:success] = 'Gespeichert'
        format.html { render :edit }
      else
        flash[:warning] = 'Konnte nicht gespeichert werden.'
        format.html { render :edit }
      end
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:spotify_playlist_id, :starts_at, :ends_at, :activated)
  end
end

# {"country"=>nil,
#   "display_name"=>nil,
#   "email"=>nil,
#   "images"=>nil,
#   "product"=>nil,
#   "external_urls"=>#<OmniAuth::AuthHash spotify="https://open.spotify.com/user/116870260">,
#   "href"=>"https://api.spotify.com/v1/users/116870260",
#   "id"=>"116870260",
#   "type"=>"user",
#   "uri"=>"spotify:user:116870260",
#   "credentials"=>#<OmniAuth::AuthHash expires=true expires_at=1412629095 refresh_token="AQBEodz2Ob2dZA7nfMjvZ3N7GiZ4BSKYaaEz-aBgtkU5jMh7AEuoXyx1DauxvSPgmDvbkuRVo3LehUx2ZqerJ_umvdm3Cdg4X4vQfivCDLEOjtDGq0el7u6Satw4bMAUvyQ" token="BQDInyfYlX6UNDCsvJ9anaSilzRs4DypV8q0yWdeo-s5vmlrSiqWd1kCXkmwFZUYYnm5ipmoTfW15G1r8ZhI6NmeNOdj0Xm6HKrNMiMao6antjLw7_ZXqH3tWphGU0wxssz0kZ2LBvmSf3eomHTJl9xzBOJZJxgArQJpDbMrLqYTUCdxgyKzICV7QFtEcQ">}
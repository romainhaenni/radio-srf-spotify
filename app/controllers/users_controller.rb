class UsersController < ApplicationController
  def edit
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @user = User.find_by(spotify_id: spotify_user.id) || User.create(name: spotify_user.display_name, spotify_id: spotify_user.id)
    @user.update_attribute :spotify_hash, spotify_user.to_hash
  end
  
  def update
    @user = User.find params[:id]
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
    params.require(:user).permit(:spotify_playlist_id, :starts_at, :ends_at, :activated, :weekend)
  end
end
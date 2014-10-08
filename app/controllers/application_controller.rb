class ApplicationController < ActionController::Base
  require 'open-uri'
  require 'rspotify'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # before_action :set_locale
  
  private
 
    def set_locale
      # HTTP_ACCEPT_LANGUAGE = en-us | de-ch
      accept_language = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless request.env['HTTP_ACCEPT_LANGUAGE'].nil?
      user_locale = params[:l] || cookies[:locale] || accept_language
      I18n.locale = (!user_locale.nil? and I18n.available_locales.include?(user_locale.to_sym)) ? user_locale : I18n.default_locale
      cookies[:locale] = I18n.locale
    end
end

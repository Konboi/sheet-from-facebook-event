class BaseController < ApplicationController

  def facebook_oauth_required
    redirect_to facebook_oauth_path and return false if facebook_user.blank?
  end

  def facebook_logged_in?
    !facebook_user.blank?
  end

  def facebook_user
    graph = Koala::Facebook::API.new(session[:facebook_access_token])
    begin
      result = graph.get_object("/me/?locale=#{get_locale}")
      return (result=='false' ? {} : result)
    rescue Exception=>e
      return {}
    end
  end

  private

  def set_locale
    I18n.locale = get_locale
  end

  def get_locale
    session[:locale] ||= I18n.default_locale
  end

end

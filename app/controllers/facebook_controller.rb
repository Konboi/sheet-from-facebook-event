# -*- coding: utf-8 -*-
class FacebookController < BaseController

  def oauth
    oauth = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::APP_SECRET, Facebook::CALLBACK_URL)
    redirect_to oauth.url_for_oauth_code(:permissions => ['user_events'] )
  end

  def callback
    oauth = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::APP_SECRET, Facebook::CALLBACK_URL)
    if params[:code]
      session[:facebook_access_token] = oauth.get_access_token(params[:code])
    else
      # TODO : ERROR HANDLING
      flash[:error] = 'facebookログインに失敗しました'
      redirect_to :root and return
    end
      flash[:notice] = 'facebookログインに成功しました'
    redirect_to :root
  end
end

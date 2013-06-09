# -*- coding: utf-8 -*-
class HomeController < BaseController
  before_action :facebook_oauth_required, :except => [:index]

  def index
  end

  def list
    graph = Koala::Facebook::API.new(session[:facebook_access_token])
    @event = graph.get_connections("me", "events", :fields => "attending, name", :locale => "ja_JP")
  end

  def generate
    @event_id = params[:event_id]
  end

  def finish
    graph = Koala::Facebook::API.new(session[:facebook_access_token])
    event = graph.get_object("#{params['event_id']}/?fields=attending,name,id&locale=ja_JP")

    session = GoogleDrive.login(params['google_id'], params['google_password'])
    ws = session.create_spreadsheet("#{event['name']}参加者一覧").worksheets[0]
    ws[1,1] = "参加者氏名"
    event['attending']['data'].each.with_index(2) do |member, index|
      ws[index, 1] = member['name']
    end
    ws.save
    flash['message'] = '作成しました。'
    redirect_to list_path
  end
end

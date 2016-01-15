class HomeController < ApplicationController
  require 'rest_client'
  require 'json'

  def index
  end

  def connect
    #render :text => home_callback_url
    redirect_to Instagram.authorize_url(:redirect_uri => home_callback_url)
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => home_callback_url)
    session[:access_token] = response.access_token
    redirect_to action: 'nav'
  end

  def nav
  end

  def tags

    client = Instagram.client(:access_token => session[:access_token])
    @tags = client.tag_search('rest')
    @media = client.tag_recent_media(@tags[0].name)
  end
end


class HomeController < ApplicationController
  require 'rest_client'
  require 'json'

  CALLBACK_URL = "http://localhost:3000/home/callback"
  def index
    #@response = HTTParty.get("https://api.instagram.com/v1/tags/rest/media/recent?access_token=2552384949.a0b5e2e.4562a4d19eff4123b473fb25364e7a2f")
    #@response = HTTParty.get("https://api.instagram.com/v1/users/self/media/liked/?access_token=2552384949.a0b5e2e.4562a4d19eff4123b473fb25364e7a2f")
  end

  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
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


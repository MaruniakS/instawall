class HomeController < ApplicationController
  require 'rest_client'
  require 'json'

  def index
  end


  def tags
    client = Instagram.client(:access_token => session[:access_token])
    @tags = client.tag_search('rest')
    @media = client.tag_recent_media(@tags[0].name)
  end
end


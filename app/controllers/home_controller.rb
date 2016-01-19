class HomeController < ApplicationController
  require 'rest_client'
  require 'json'

  def index
  end

  def tags
    hashtags = params[:tag]
    tags = current_user.instagram_client.tag_search(hashtags)
    media = current_user.instagram_client.tag_recent_media(tags[0].name)
    render json: media
  end

end


class HomeController < ApplicationController
  require 'rest_client'
  require 'json'

  def index

  end

  def tags
    str = params[:tag] #hashtags as string
    @hashtags = str.split(/[# ]/).reject(&:empty?) #hashtags in array without #
    save_hashtags
    tags = current_user.instagram_client.tag_search(@hashtags[0])
    media = current_user.instagram_client.tag_recent_media(tags[0].name)
    render json: media
  end

  private
  def save_hashtags
    @hashtags.each do |h|
      tag = Hashtag.find_by_tag_name(h)
      if tag.nil?
        tag = Hashtag.new(tag_name: h)
        tag.save
        #UserHashtag.create(user: current_user, hashtag: tag)
      else
        tag.count += 1
        tag.save!
      end
    end
  end

end


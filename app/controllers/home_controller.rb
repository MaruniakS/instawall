class HomeController < ApplicationController

  def index
  end

  def tags
    render :partial => 'shared/tags'
  end

  def get_photos
    tag_name = params[:tag]
    max_id = params[:max_id]
    if max_id.blank?
      save_tag(tag_name)
      media = current_user.instagram_client.tag_recent_media(tag_name, count: 5)
    else
      media = current_user.instagram_client.tag_recent_media(tag_name, count: 5, max_id: max_id)
    end
    render json: result(media)
  end

  def recent_media
    max_id = params[:max_id]
    media = max_id.blank? ? current_user.instagram_client.user_recent_media(count: 5) :  current_user.instagram_client.user_recent_media(count: 5, max_id: max_id)
    render json: result(media)
  end

  def tmp
    hash_tags = ['nat']
    media = current_user.instagram_client.tag_recent_media('nature')
    result = {
        #'hash_tags' => hash_tags,
        'pagination' => media.pagination,
        'meta' => media.meta,
        'data' => media
    }
    render json: result(media)
  end

  private
  def result(media)
    res = {
        'pagination' => media.pagination,
        'meta' => media.meta,
        'photos' => media
    }
    res
  end

  def save_tag(tag_name)
    return if !user_signed_in?
    return if (tag_name.nil? || tag_name.empty?)
      tag = Tag.find_by_name(tag_name)
      if tag.nil?
        tag = Tag.create(name: tag_name)
        UserTag.create(user: current_user, tag: tag)
      else
        tag.count += 1
        tag.save!
      end
  end

  def auth
    redirect_to user_omniauth_authorize_path(:instagram)
  end

end


class HomeController < ApplicationController

  def index
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
    result = {
        'pagination' => media.pagination,
        'meta' => media.meta,
        'photos' => media
    }
    render json: result
  end

  def tmp
    hash_tags = ['nature']
    media = current_user.instagram_client.tag_recent_media(hash_tags[0], count: 20)
    result = {
        'hash_tags' => hash_tags,
        'pagination' => media.pagination,
        'meta' => media.meta,
        'data' => media
    }
    render json: result
  end

  private
  def save_tag(tag_name)
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


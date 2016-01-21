class HomeController < ApplicationController
  before_filter :init_cache
  def index
  end

  def tags
    render :partial => 'shared/tags'
  end

  def get_photos
    tag_name = params[:tag]
    max_id = params[:max_id]
    cache = Cache.get_response(current_user.id, request.original_url)
    render json: cache and return if cache
    if max_id.blank?
      save_tag(tag_name)
      media = current_user.instagram_client.tag_recent_media(tag_name, count: 5)
    else
      media = current_user.instagram_client.tag_recent_media(tag_name, count: 5, max_id: max_id)
    end
    render json: Cache.add_to_cache(current_user.id, request.original_url, result(media))
  end

  def recent_media
    max_id = params[:max_id]
    cache = Cache.get_response(current_user.id, request.original_url)
    render json: cache and return if cache
    media = max_id.blank? ? current_user.instagram_client.user_recent_media(count: 5) :  current_user.instagram_client.user_recent_media(count: 5, max_id: max_id)
    render json: Cache.add_to_cache(current_user.id, request.original_url, result(media))
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
      else
        tag.count += 1
        tag.save!
      end
    if UserTag.find_by_user_id_and_tag_id(user: current_user, tag: tag).nil?
      UserTag.create(user: current_user, tag: tag)
    end
  end
end


class HomeController < ApplicationController
  def index

  end

  def photos_by_tags
    str = params[:tag] #hashtags as string
    hash_tags = str.split(/[# ]/).reject(&:empty?) #hashtags in array without #
    save_tags(hash_tags)
    tags = current_user.instagram_client.tag_search(hash_tags[0])
    media = current_user.instagram_client.tag_recent_media(tags[0].name, count: 5)
    result = {
        'hash_tags' => hash_tags,
        'pagination' => media.pagination,
        'meta' => media.meta,
        'photos' => media
    }
    render json: result
  end

  def load_more
    tag = params[:tag]
    max_id = params[:max_id]
    media = current_user.instagram_client.tag_recent_media(tag, count: 5, max_id: max_id)
    result = {
        'pagination' => media.pagination,
        'meta' => media.meta,
        'photos' => media
    }

    render json: result
  end

  def tmp
    hash_tags = ['nature']
    media = current_user.instagram_client.tag_recent_media(hash_tags[0], count: 5)
    result = {
        'hash_tags' => hash_tags,
        'pagination' => media.pagination,
        'meta' => media.meta,
        'data' => media
    }
    render json: result
  end

  private
  def save_tags(hash_tags)
    hash_tags.each do |h|
      tag = Tag.find_by_name(h)
      if tag.nil?
        tag = Tag.create(name: h)
        UserTag.create(user: current_user, tag: tag)
      else
        tag.count += 1
        tag.save!
      end
    end
  end

end


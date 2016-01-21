class Cache < ActiveRecord::Base
  def self.init_cache
    $cache = {} unless $cache
  end

  def self.get_cache
    $cache
  end

  def self.get_response(id, url)
    if $cache.has_key? id
      if (($cache[id].has_key? url) && Time.now -  $cache[id][url][0] < 60)
        return $cache[id][url][1]
      end
    end
    return false
  end

  def self.add_to_cache(id, url, response)
    if $cache.has_key? id
      $cache[id][url] = [Time.now, response]
    else
      $cache[id] = Hash[url, [Time.now, response]]
    end
    $cache[id][url][1]
  end

end

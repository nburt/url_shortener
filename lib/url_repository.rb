class UrlRepository
  attr_reader :urls

  def initialize
    @urls = []
  end

  def shorten(id, url)
    url_hash = {}
    url_hash[:original_url] = url
    url_hash[:url_id] = id.to_s
    url_hash[:stats] = true
    url_hash[:total_visits] = 0
    url_hash
  end

end
class UrlShortener
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def shorten(id)
    url_hash = {}
    url_hash[self.url] = id
    url_hash
  end
end
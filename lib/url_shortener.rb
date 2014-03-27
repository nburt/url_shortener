class UrlShortener
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def shorten(id, domain)
    url_hash = {}
    url_hash[:old_url] = url
    url_hash[:new_url] = "#{domain}#{id}"
    url_hash
  end
end
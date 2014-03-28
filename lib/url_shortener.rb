class UrlShortener
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def shorten(id, domain)
    url_hash = {}
    url_hash[:old_url] = create_usable_url(id, @url)
    url_hash[:new_url] = "#{domain}#{id}"
    url_hash
  end

  def create_usable_url(id, url)
    if /(https:\/\/)/.match(url) != nil
      "#{url}"
    elsif /(http:\/\/)/.match(url) != nil
      "#{url}"
    else
      "http://#{url}"
    end
  end
end
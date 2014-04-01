class UrlShortener
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def shorten(id, domain)
    url_hash = {}
    url_hash[:old_url] = create_usable_url
    url_hash[:new_url] = "#{domain}#{id}"
    url_hash[:stats] = true
    url_hash
  end

  def create_usable_url
    if /(https:\/\/)/.match(@url) != nil
      "#{url}"
    elsif /(http:\/\/)/.match(@url) != nil
      "#{url}"
    else
      "http://#{url}"
    end
  end

  def url_is_valid?
    url_to_check = create_usable_url
    !!(url_to_check =~ URI::DEFAULT_PARSER.regexp[:ABS_URI] && /[.][A-Za-z]{2,}/.match(@url) != nil)
  end
end
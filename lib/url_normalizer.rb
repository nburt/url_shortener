class UrlNormalizer
  def initialize(url)
    @url = url
  end

  def result
    if /(^https:\/\/)/.match(@url) != nil
      "#{@url}"
    elsif /(^http:\/\/)/.match(@url) != nil
      "#{@url}"
    else
      "http://#{@url}"
    end
  end
end
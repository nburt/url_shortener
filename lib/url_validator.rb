require_relative '../lib/url_validation_result'
require_relative '../lib/url_helpers'
require_relative '../lib/url_normalizer'

include UrlHelpers

class UrlValidator

  def validate(url)
    if url.empty?
      ValidationUrlResult.new(false, "The URL cannot be blank.")
    elsif !url.start_with?("http://") || url !~ /[.][A-Za-z]{2,}/
      ValidationUrlResult.new(false, "The text you entered is not a valid URL.")
    else
      usable_url = UrlNormalizer.new(url).result
      ValidationUrlResult.new(true, usable_url)
    end
  end

end
class UrlRepository
  attr_reader :urls

  def initialize
    @urls = []
  end

  def display
    urls
  end

end
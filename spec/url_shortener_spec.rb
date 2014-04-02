require 'spec_helper'
require 'url_shortener'

describe UrlShortener do
  it 'can generate a new url from a given url' do
    url = UrlShortener.new('www.gschool.it')
    expect(url.shorten(1, 'http://localhost:9292/')).to eq ({:old_url => 'http://www.gschool.it',
                                                             :new_url => 'http://localhost:9292/1',
                                                             :stats => true,
                                                             :total_visits => 0})
  end

  it 'returns false if an invalid URL is entered into shortener' do
    url = UrlShortener.new('some string')
    expect(url.url_is_valid?).to eq false
  end

  it 'returns true if a valid URL is entered into shortener' do
    url = UrlShortener.new('http://google.com')
    expect(url.url_is_valid?).to eq true
  end
end
require 'spec_helper'
require 'url_shortener'

describe UrlShortener do
  it 'can generate a new url from a given url' do
    url = UrlShortener.new('www.gschool.it')
    expect(url.shorten(1, "http://localhost:9292/")).to eq ({ :old_url => 'www.gschool.it' , :new_url => "http://localhost:9292/1"})
  end
end
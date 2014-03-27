require 'spec_helper'
require 'url_shortener'

describe UrlShortener do
  it 'can generate a new url from a given url' do
    url = UrlShortener.new('www.gschool.it')
    expect(url.shorten(1)).to eq ({ :old_url => 'www.gschool.it', :new_url_id => 1 })
  end
end
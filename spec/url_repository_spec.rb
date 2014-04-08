require 'spec_helper'
require 'url_repository'

describe UrlRepository do

  it 'can generate a new url from a given url' do
    url = UrlRepository.new
    expect(url.shorten(1, 'www.gschool.it')).to eq ({:original_url => 'www.gschool.it',
                                                     :url_id => '1',
                                                     :stats => true,
                                                     :total_visits => 0})
  end

end
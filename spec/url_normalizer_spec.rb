require 'spec_helper'
require 'url_normalizer'

describe UrlNormalizer do

  it 'should add http to a url if it does not already have http or https' do
    url_normalizer = UrlNormalizer.new('google.com')
    expect(url_normalizer.result).to eq 'http://google.com'
  end

end
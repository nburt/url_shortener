require 'spec_helper'
require 'url_validator'

describe UrlValidator do

  it 'should return true when the url is valid' do
    expect(UrlValidator.new('google.com').url_is_valid?).to eq true
  end

  it 'should return false when the url is invalid' do
    expect(UrlValidator.new('sgsdfsd').url_is_valid?).to eq false
  end

end


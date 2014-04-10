require 'spec_helper'
require 'vanity_url_validator'
require 'url_repository'
require './app'

describe VanityUrlValidator do
  before do
    DB[:urls].delete
  end

  it 'displays an error if the vanity url is longer than 12 characters' do
    vanity_url_validator = VanityUrlValidator.new(DB)
    result = vanity_url_validator.validate_vanity('goodbyeeeeeeeeeee')

    expect(result.is_valid?).to eq false
    expect(result.vanity_error_message).to eq 'Sorry, vanity URLs cannot be longer than 12 characters.'
  end

  it 'displays an error if the vanity url is already taken' do
    vanity_url_validator = VanityUrlValidator.new(DB)
    UrlRepository.new(DB).insert('www.google.com', 'hi')
    result = vanity_url_validator.validate_vanity('hi')

    expect(result.is_valid?).to eq false
    expect(result.vanity_error_message).to eq 'Sorry, that vanity URL has already been taken.'

  end

  it 'displays an error if there are numbers in the vanity url' do
    vanity_url_validator = VanityUrlValidator.new(DB)
    result = vanity_url_validator.validate_vanity('hello12345')

    expect(result.is_valid?).to eq false
    expect(result.vanity_error_message).to eq 'Sorry, vanity URLs can only contain letters.'
  end

  it 'displays an error if there are special characters in the vanity url' do
    vanity_url_validator = VanityUrlValidator.new(DB)
    result = vanity_url_validator.validate_vanity('hello$*&^')

    expect(result.is_valid?).to eq false
    expect(result.vanity_error_message).to eq 'Sorry, vanity URLs can only contain letters.'
  end

  it 'displays an error if there is profanity in the vanity url'
end
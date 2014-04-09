require 'spec_helper'
require 'url_repository'
require 'sequel'

describe UrlRepository do

  before do
    DB[:urls].delete
    @url_repository = UrlRepository.new(DB)
  end

  it 'can find urls by id' do
    id = @url_repository.insert('www.google.com')
    @url_repository.insert('www.gschool.it')
    expect(@url_repository.get_original_url(id.to_s)).to eq 'www.google.com'
  end

  it 'can update visits in the table' do
    id = @url_repository.insert('www.google.com')
    @url_repository.add_visit(id.to_s)
    @url_repository.add_visit(id.to_s)
    expect(@url_repository.get_visits(id.to_s)).to eq 2
  end

  it 'can add the vanity url to the url' do
    id = @url_repository.insert('www.google.com', 'google')
    expect(@url_repository.get_vanity_url(id.to_s)).to eq 'google'
  end
end
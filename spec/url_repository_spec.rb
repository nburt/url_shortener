require 'spec_helper'
require 'url_repository'

describe UrlRepository do
  it 'repository initiates with an empty array' do
    repository = UrlRepository.new

    expect(repository.display).to eq []
  end
end
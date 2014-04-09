require 'spec_helper'
require 'url_repository'
require 'sequel'

describe UrlRepository do

  before do
    DB[:urls].delete
    @url_repository = UrlRepository.new(DB)
  end

  it 'can insert urls into a table and display them' do
    id = @url_repository.insert('www.google.com')
    expect(@url_repository.display_all).to eq [
                                                {:id => id,
                                                 :original_url => 'www.google.com',
                                                 :total_visits => @url_repository.get_visits(id)}
                                              ]
  end

  it 'can find records by id' do
    id = @url_repository.insert('www.google.com')
    @url_repository.insert('www.gschool.it')
    expect(@url_repository.display_row(id)).to eq ({:id => id,
                                                    :original_url => 'www.google.com',
                                                    :total_visits => @url_repository.get_visits(id)})
  end

  it 'can update visits in the table' do
    id = @url_repository.insert('www.google.com')
    @url_repository.add_visit(id)
    @url_repository.add_visit(id)
    expect(@url_repository.get_visits(id)).to eq 2
  end

end
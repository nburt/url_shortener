require 'sinatra'
require 'sinatra/base'
require './lib/url_repository'
require './lib/url_shortener'

class App < Sinatra::Base

  LINKS_REPO = UrlRepository.new

  get '/' do
    erb :index
  end

  post '/' do
    id = LINKS_REPO.urls.count + 1
    LINKS_REPO.urls << UrlShortener.new(params[:url]).shorten(id, request.url)
    redirect "/stats/#{id}"
  end

  get '/stats/:id' do
    id = params[:id].to_i
    erb :show_stats, :locals => { :old_url => LINKS_REPO.urls[id-1][:old_url], :new_url => LINKS_REPO.urls[id-1][:new_url] }
  end
end
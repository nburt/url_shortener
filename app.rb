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
    stats = LINKS_REPO.urls[id -1][:stats]
    redirect "/#{id}?stats=#{stats}"
  end

  get '/:id?stats=true' do
    #id = params[:id].to_i
    #erb :show_stats, :locals => { :old_url => LINKS_REPO.urls[id-1][:old_url], :new_url => LINKS_REPO.urls[id-1][:new_url] }
  end

  get '/:id' do
    if params[:stats]
      id = params[:id].to_i
      erb :show_stats, :locals => {:old_url => LINKS_REPO.urls[id-1][:old_url], :new_url => LINKS_REPO.urls[id-1][:new_url]}
    else
      redirect LINKS_REPO.urls[(params[:id].to_i) - 1][:old_url]
    end
  end
end
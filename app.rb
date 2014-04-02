require 'sinatra/base'
require './lib/url_repository'
require './lib/url_shortener'
require './lib/error_message'

class App < Sinatra::Base

  LINKS_REPO = UrlRepository.new

  enable :sessions

  get '/' do
    erb :index
  end

  post '/' do
    id = LINKS_REPO.urls.count + 1
    url = params[:url]
    if UrlShortener.new(url).url_is_valid?
      LINKS_REPO.urls << UrlShortener.new(url).shorten(id, request.url)
      stats = LINKS_REPO.urls[id-1][:stats]
      redirect "/#{id}?stats=#{stats}"
    elsif url.empty?
      session[:message] = ErrorMessage.new.blank
      redirect '/'
    else
      session[:message] = ErrorMessage.new.invalid
      redirect '/'
    end
  end

  get '/:id' do
    id = params[:id].to_i
    url_hash = LINKS_REPO.urls[id-1]
    if params[:stats]
      erb :show_stats, :locals => {:old_url => url_hash[:old_url], :new_url => url_hash[:new_url], :visit_count => url_hash[:total_visits]}
    else
      url_hash[:total_visits] += 1
      redirect LINKS_REPO.urls[(params[:id].to_i) - 1][:old_url]
    end
  end
end
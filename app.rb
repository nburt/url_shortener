require 'sinatra/base'
require './lib/url_repository'
require './lib/url_helpers'
require './lib/url_validator'

class App < Sinatra::Base

  include UrlHelpers

  ERROR_INVALID = "The text you entered is not a valid URL."
  ERROR_BLANK = "The URL cannot be blank."
  LINKS_REPO = UrlRepository.new

  enable :sessions

  get '/' do
    erb :index
  end

  post '/' do
    id = LINKS_REPO.urls.count + 1
    url = params[:url]
    url_to_shorten = UrlValidator.new(url)
    if url_to_shorten.url_is_valid?
      usable_url = url_to_shorten.create_usable_url
      LINKS_REPO.urls << LINKS_REPO.shorten(id, usable_url)
      stats = LINKS_REPO.urls[id - 1][:stats]
      redirect link_path(id, stats)
    elsif url.empty?
      session[:message] = ERROR_BLANK
      redirect root_path
    else
      session[:message] = ERROR_INVALID
      redirect root_path
    end
  end

  get '/:id' do
    id = params[:id].to_i
    url_hash = LINKS_REPO.urls[id - 1]
    if params[:stats]
      erb :show_stats, :locals => {:original_url => url_hash[:original_url],
                                   :url_id => url_hash[:url_id],
                                   :visit_count => url_hash[:total_visits]}
    else
      url_hash[:total_visits] += 1
      redirect LINKS_REPO.urls[id - 1][:original_url]
    end
  end
end
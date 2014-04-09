require 'sinatra/base'
require './lib/url_repository'
require './lib/url_helpers'
require './lib/url_validator'
require './lib/url_normalizer'

class App < Sinatra::Base

  include UrlHelpers

  def self.links_repo
    @links_repo ||= UrlRepository.new
  end

  def self.reset_links_repo
    @links_repo = UrlRepository.new
  end

  def links_repo
    self.class.links_repo
  end

  enable :sessions

  get '/' do
    erb :index
  end

  post '/' do
    id = links_repo.urls.count + 1
    url = params[:url]
    validator = UrlValidator.new
    validation_result = validator.validate(url)
    if validation_result.success?
      links_repo.urls << links_repo.shorten(id, url)
      stats = links_repo.urls[id - 1][:stats]
      redirect stats_path(id, stats)
    else
      session[:message] = validation_result.error_message
      redirect root_path
    end
  end

  get '/:id' do
    id = params[:id].to_i
    url_hash = links_repo.urls[id - 1]
    if params[:stats]
      erb :show_stats, :locals => {:original_url => url_hash[:original_url],
                                   :url_id => url_hash[:url_id],
                                   :visit_count => url_hash[:total_visits]}
    else
      url_hash[:total_visits] += 1
      redirect links_repo.urls[id - 1][:original_url]
    end
  end
end
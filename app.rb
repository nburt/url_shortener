require 'sinatra/base'
require './lib/url_repository'
require './lib/url_helpers'
require './lib/url_validator'
require './lib/url_normalizer'

class App < Sinatra::Base

  include UrlHelpers

  def self.links_repo
    @links_repo ||= UrlRepository.new(DB)
  end

  def self.reset_links_repo(db)
    @links_repo = UrlRepository.new(db)
  end

  def links_repo
    self.class.links_repo
  end

  enable :sessions

  get '/' do
    erb :index
  end

  post '/' do
    url = params[:url]
    validator = UrlValidator.new
    validation_result = validator.validate(url)
    if validation_result.success?
      id = links_repo.insert(UrlNormalizer.new(url).result)
      redirect stats_path(id)
    else
      session[:message] = validation_result.error_message
      redirect root_path
    end
  end

  get '/:id' do
    id = params[:id].to_i
    url_hash = links_repo.display_row(id)
    if params[:stats]
      erb :show_stats, :locals => {:original_url => url_hash[:original_url],
                                   :url_id => url_hash[:id],
                                   :visit_count => url_hash[:total_visits]}
    else
      links_repo.add_visit(id)
      redirect links_repo.display_row(id)[:original_url]
    end
  end
end
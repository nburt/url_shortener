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
    vanity_url = params[:vanity_url]
    validator = UrlValidator.new
    validation_result = validator.validate(url)
    if validation_result.success?
      identification = links_repo.insert(UrlNormalizer.new(url).result, vanity_url)
      redirect stats_path(identification)
    else
      session[:message] = validation_result.error_message
      redirect root_path
    end
  end

  get '/:id' do
    identification = params[:id]
    original_url = links_repo.get_original_url(identification)
    if params[:stats]
      erb :show_stats, :locals => {:original_url => original_url,
                                   :url_id => identification,
                                   :visit_count => links_repo.get_visits(identification),
                                   :vanity_url => links_repo.get_vanity_url(identification)}
    else
      links_repo.add_visit(identification)
      redirect links_repo.get_original_url(identification)
    end
  end
end
require 'sinatra/base'
require './lib/url_repository'
require './lib/url_helpers'
require './lib/url_validator'
require './lib/url_normalizer'
require './lib/vanity_url_validator'
require './lib/vanity_url_validation_result'

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
    vanity_validator = VanityUrlValidator.new(DB)
    vanity_validation_result = vanity_validator.validate_vanity(vanity_url)
    validation_result = validator.validate(url)

    if validation_result.success? && vanity_validation_result.is_valid?
      identification = links_repo.insert(UrlNormalizer.new(url).result, vanity_url)
      redirect stats_path(identification)
    else
      session[:message] = validation_result.error_message
      if !vanity_validation_result.is_valid?
        session[:vanity_message] = vanity_validation_result.vanity_error_message
      end
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
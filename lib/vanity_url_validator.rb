require './lib/vanity_url_validation_result'

class VanityUrlValidator

  def initialize(db)
    @db_table = db[:urls]
  end

  def validate_vanity(vanity_url)
    if vanity_url == ""
      VanityValidationResult.new(true, "")
    elsif !@db_table[:vanity_url => vanity_url].nil?
      VanityValidationResult.new(false, "Sorry, that vanity URL has already been taken.")
    elsif vanity_url.length >= 12
      VanityValidationResult.new(false, "Sorry, vanity URLs cannot be longer than 12 characters.")
    elsif vanity_url =~ /\d/
      VanityValidationResult.new(false, "Sorry, vanity URLs can only contain letters.")
    elsif vanity_url =~ /\W/
      VanityValidationResult.new(false, "Sorry, vanity URLs can only contain letters.")
    else
      VanityValidationResult.new(true, "")
    end
  end

end


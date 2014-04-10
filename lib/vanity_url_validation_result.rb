class VanityValidationResult
  attr_reader :vanity_error_message

  def initialize(valid, vanity_error_message)
    @valid = valid
    @vanity_error_message = vanity_error_message
  end

  def is_valid?
    @valid
  end

end
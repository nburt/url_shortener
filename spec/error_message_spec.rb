require 'spec_helper'
require 'error_message'

describe 'error messages' do
  it 'returns an error message if the URL is invalid' do
    message = ErrorMessage.new
    expect(message.invalid).to eq 'The text you entered is not a valid URL.'
  end
end

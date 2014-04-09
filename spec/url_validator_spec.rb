require 'url_validator'

describe UrlValidator do
  it 'returns a successful result if url is valid' do
    validator = UrlValidator.new
    result = validator.validate('http://google.com')

    expect(result.success?).to eq true
  end

  it 'returns an unsuccessful result if the url is not a url' do
    validator = UrlValidator.new
    result = validator.validate('sdfoihdsf')

    expect(result.success?).to eq false
    expect(result.error_message).to eq 'The text you entered is not a valid URL.'
  end

  it 'returns an unsuccessful result if the url is blank' do
    validator = UrlValidator.new
    result = validator.validate('')

    expect(result.success?).to eq false
    expect(result.error_message).to eq 'The URL cannot be blank.'
  end

  it 'returns unsuccessful if the url starts with http but is not a valid url' do
    validator = UrlValidator.new
    result = validator.validate('http://google')

    expect(result.success?).to eq false
  end

  it 'returns successful if the url starts with http and ends with a high level domain other than .com' do
    validator = UrlValidator.new
    result = validator.validate('http://gschool.it')

    expect(result.success?).to eq true
  end
end
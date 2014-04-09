require 'spec_helper'
require 'url_helpers'
include UrlHelpers

describe UrlHelpers do

  it 'creates a path to the stats page' do
    expect(stats_path(1, true)).to eq '/1?stats=true'
  end

  it 'creates a root path' do
    expect(root_path).to eq '/'
  end

end
require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = App

feature 'setting up url shortener app' do
  scenario 'user can see homepage with a form with placeholder text' do
    visit '/'
    expect(page).to be
  end
end
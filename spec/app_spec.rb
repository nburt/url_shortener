require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = App

feature 'setting up url shortener app' do
  scenario 'user can see homepage with a form with placeholder text' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'Text'
    within 'form' do
      click_button 'Shorten'
    end
  end
end
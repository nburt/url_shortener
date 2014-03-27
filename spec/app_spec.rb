require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = App
Capybara.app_host = 'http://localhost:9292'

feature 'setting up url shortener app' do
  scenario 'user can submit a link and see the new shortened url' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'www.gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'www.gschool.it'
    expect(page).to have_content 'http://localhost:9292/1'
  end
end
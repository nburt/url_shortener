require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = App
Capybara.app_host = 'http://localhost:9292'

feature 'setting up url shortener app' do

  before { App.reset_links_repo }

  let(:current_link_path) { '/1' }
  let(:current_link_stats_path) { "#{current_link_path}?stats=true" }

  scenario 'user can submit a link, see the new shortened url, and is redirected to the original url if they click on it' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'http://gschool.it'
    visit current_link_path
    expect(current_url).to eq 'http://gschool.it/'

    visit '/'
    fill_in 'Enter URL to shorten', :with => 'www.gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'www.gschool.it'
    visit 'http://localhost:9292/2'
    expect(current_url).to eq 'http://www.gschool.it/'

    visit '/'
    fill_in 'Enter URL to shorten', :with => 'gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'gschool.it'
    visit 'http://localhost:9292/3'
    expect(current_url).to eq 'http://gschool.it/'
  end

  scenario 'user can return to the homepage to shorten another link' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    click_link '"Shorten" another URL'
  end

  scenario 'user will see an error message if they enter a blank url' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => ''
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'The URL cannot be blank'
  end

  scenario 'user will not see an error message when they refresh the page' do
    visit '/'
    expect(page).to_not have_content 'The URL cannot be blank'
  end

  scenario 'user will see the number of times the shortened URL has been clicked on the stats page' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://google.com'
    within 'form' do
      click_button 'Shorten'
    end

    # Initial visit count should be 0
    expect(page).to have_content 'Visits: 0'

    # Visit count should increment each time I visit the link
    5.times do
      visit current_link_path
    end

    # Visit count should not increment when hitting the stats path
    5.times do
      visit current_link_stats_path
    end
    visit current_link_stats_path
    expect(page).to have_content 'Visits: 5'
  end
end
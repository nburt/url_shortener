require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = App
Capybara.app_host = 'http://localhost:9292'

feature 'setting up url shortener app' do
  scenario 'user can submit a link, see the new shortened url, and is redirected to the original url if they click on it' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'http://gschool.it'
    visit 'http://localhost:9292/1'
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

    the 'user can return to the homepage to shorten another link' do
      visit '/'
      fill_in 'Enter URL to shorten', :with => 'gschool.it'
      within 'form' do
        click_button 'Shorten'
      end
      click_link '"Shorten" another URL'
    end

    and_the 'user sees an error message on the homepage if they enter an invalid url' do
      visit '/'
      fill_in 'Enter URL to shorten', :with => 'gschool'
      within 'form' do
        click_button 'Shorten'
      end
      expect(page).to have_content 'The text you entered is not a valid URL.'
    end

    and_the 'user sees and error message on the homepage if they leave the input field blank' do
      visit '/'
      fill_in 'Enter URL to shorten', :with => ''
      within 'form' do
        click_button 'Shorten'
      end
      expect(page).to have_content 'The URL cannot be blank'
    end

    and_the 'user will see the number of times the shortened URL has been clicked on the stats page' do
      visit '/'
      fill_in 'Enter URL to shorten', :with => 'google.com'
      within 'form' do
        click_button 'Shorten'
      end
      expect(page).to have_content 'Number of shortened URL visits: 0'
      5.times do
        visit '/5'
      end
      5.times do
        visit '/1?stats=true'
      end
      visit '/5?stats=true'
      expect(page).to have_content 'Number of shortened URL visits: 5'
    end
  end
end
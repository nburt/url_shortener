require 'spec_helper'
require 'capybara/rspec'
require './app'

Capybara.app = App
Capybara.app_host = 'http://localhost:9292'

feature 'setting up url shortener app' do

  before do
    DB[:urls].delete
  end

  scenario 'user can submit a link, see the new shortened url, and is redirected to the original url if they click on it' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'http://gschool.it'
    id = id_of_created_url(current_path)
    expect(page).to have_content "http://localhost:9292/#{id}"
    visit "/#{id}"
    expect(current_url).to eq 'http://gschool.it/'

    visit '/'
    fill_in 'Enter URL to shorten', :with => 'www.gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'www.gschool.it'
    id = id_of_created_url(current_path)
    visit "http://localhost:9292/#{id}"
    expect(current_url).to eq 'http://www.gschool.it/'

    visit '/'
    fill_in 'Enter URL to shorten', :with => 'gschool.it'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'gschool.it'
    id = id_of_created_url(current_path)
    visit "http://localhost:9292/#{id}"
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
    id = id_of_created_url(current_path)

    the 'Initial visit count should be 0' do
      expect(page).to have_content 'Visits: 0'
    end

    and_the 'Visit count should increment each time I visit the link' do
      5.times do
        visit "/#{id}"
      end
    end

    and_the 'Visit count should not increment when hitting the stats path' do
      5.times do
        visit "/#{id}?stats=true"
      end
      visit "/#{id}?stats=true"
      expect(page).to have_content 'Visits: 5'
    end
  end

  scenario 'user can enter in a vanity url' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://google.com'
    fill_in 'Enter vanity URL', :with => 'google'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'http://google.com'
    id = id_of_created_url(current_path)
    expect(page).to have_content 'http://localhost:9292/google'
    visit '/google'
    expect(current_url).to eq 'http://google.com/'

    and_the 'user will see an error if the vanity url has already been taken' do
      visit '/'
      fill_in 'Enter URL to shorten', :with => 'http://google.com'
      fill_in 'Enter vanity URL', :with => 'google'
      within 'form' do
        click_button 'Shorten'
      end
      expect(page).to have_content 'Sorry, that vanity URL has already been taken.'
    end

    and_the 'user will see an error if the vanity url is longer than 12 characters' do
      visit '/'
      fill_in 'Enter URL to shorten', :with => 'http://google.com'
      fill_in 'Enter vanity URL', :with => 'googleeeeeeeeeeeeeee'
      within 'form' do
        click_button 'Shorten'
      end
      expect(page).to have_content 'Sorry, vanity URLs cannot be longer than 12 characters.'
    end
  end

  scenario 'user enters an invalid url and a vanity url that has already been taken' do
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://google.com'
    fill_in 'Enter vanity URL', :with => 'google'
    within 'form' do
      click_button 'Shorten'
    end
    visit '/'
    fill_in 'Enter URL to shorten', :with => 'http://google'
    fill_in 'Enter vanity URL', :with => 'google'
    within 'form' do
      click_button 'Shorten'
    end
    expect(page).to have_content 'The text you entered is not a valid URL.'
    expect(page).to have_content 'Sorry, that vanity URL has already been taken.'
  end

end
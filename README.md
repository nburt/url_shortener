URL Shortener

#Project URLs

Tracker Project:
https://www.pivotaltracker.com/n/projects/1047372

Staging environment:
http://sheltered-chamber-7594.herokuapp.com

Production environment:
http://sheltered-shore-2572.herokuapp.com

#Development

The URL shortener allows the user to shorten URLs for readability and easier sharing
on social media.

#Getting Started

1. `bundle install`

Bundler will download and install the required gems to run the URL shortener

1. Create databases by running `psql -d postgres -f scripts/create_database.sql`

1. Run migrations by typing `rake db:migrate`

1. Run test suite with `rspec`

1. Type `rerun rackup` to initiate the local server, `rerun` will reload the app when file changes are detected

#Migrations on Heroku

heroku run 'sequel -m migrations $HEROKU_POSTGRESQL_PINK_URL' --app sheltered-chamber-7594
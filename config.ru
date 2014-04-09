require 'sequel'
require 'dotenv'
Dotenv.load

database_url = if !ENV['HEROKU_POSTGRESQL_PINK_URL'].nil?
                 ENV['HEROKU_POSTGRESQL_PINK_URL']
               else
                 ENB['DATABASE_URL']
               end

DB = Sequel.connect(database_url)

require './app'

run App
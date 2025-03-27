# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 2.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

gem 'activerecord-import'
gem 'bcrypt', '~> 3.1.7'
gem 'config'
gem 'jwt'
gem 'panko_serializer'
gem 'pg', '>= 0.18', '< 2.0'
gem 'rswag-api'
gem 'rswag-ui'
gem 'simple_command'

group :development, :test do
  gem 'awesome_print'
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'factory_bot_rails'
  gem 'pry', '~> 0.14.2'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 7.0.0'
  gem 'rswag-specs'
  gem 'rubocop', '~> 1.54.1', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'annotate'
  gem 'listen', '~> 3.8'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'faker'
  gem 'shoulda-matchers', '~> 5.3.0'
  gem 'simplecov', require: false
end

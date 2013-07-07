source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'compass-rails', github: 'milgner/compass-rails', branch: 'rails4'
gem 'animate-sass', '~> 0.1.1'

# Use HAML templates
gem 'haml-rails', '~> 0.4'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.0.0'

gem 'wiselinks', '~> 0.7.0'

gem 'simple_form', github: 'plataformatec/simple_form',
                   ref: 'dcf4862972792abafeefd73f6b1d385322a64115'

gem 'draper', '~> 1.2.1'

gem 'ranked-model', '~> 0.2.1'

gem 'dalli', '~> 2.6.4'

gem 'puma', '~> 2.3.1'

gem 'nokogiri'
gem 'css_parser'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'listen'
  gem 'guard'
  gem 'guard-rspec'
  gem 'letter_opener'
  gem 'spring'
  gem 'quiet_assets'
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'capistrano-zen'
end

group :test do
  gem 'capybara'
  gem 'capybara-email', '~> 2.1.0'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'bogus'
end

group :test, :development do
  gem 'pry-nav'
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl', github: 'thoughtbot/factory_girl'
  gem 'factory_girl_rails', '~> 4.2.1'
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'factory_girl'
require 'capybara/rspec'
require 'capybara/email/rspec'
require 'simplecov'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

SimpleCov.start 'rails'
Draper::ViewContext.test_strategy :fast
Capybara.javascript_driver = :webkit
DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::Email::DSL, type: :feature

  config.use_transactional_fixtures = false

  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each, js: true, pre_count: true do
    DatabaseCleaner.strategy = :truncation, {:pre_count => true}
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

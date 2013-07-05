require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module Tasking
  class Application < Rails::Application
    config.time_zone = 'Pacific Time (US & Canada)'

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    config.generators do |g|
      g.helper false
    end

    console do
      config.console = Pry
    end
  end
end

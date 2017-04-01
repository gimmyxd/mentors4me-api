# frozen_string_literal: true
require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mentors4meApi
  class Application < Rails::Application
    config.time_zone = 'Bucharest'
    config.active_record.default_timezone = :local

    ActionMailer::Base.delivery_method = :smtp
    config.api_only = true
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.eager_load_paths += %W(#{config.root}/models)
    config.eager_load_paths += Dir["#{config.root}/models/**/"]
    config.autoload_paths += Dir[Rails.root.join('app', 'docs', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'utils', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'abilities', '*')]
    config.autoload_paths += Dir[Rails.root.join('lib', 'custom', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*')]

    config.eager_load_paths += [
      "#{Rails.root}/lib",
      "#{Rails.root}/lib/custom",
      "#{Rails.root}/app/docs",
      "#{Rails.root}/app/abilities",
      "#{Rails.root}/app/utils",
      "#{Rails.root}/app/services"
    ]

    config.autoload_paths += [
      "#{Rails.root}/lib",
      "#{Rails.root}/lib/custom",
      "#{Rails.root}/app/docs",
      "#{Rails.root}/app/abilities",
      "#{Rails.root}/app/utils",
      "#{Rails.root}/app/services"
    ]

    # Rspec config
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end
  end
end

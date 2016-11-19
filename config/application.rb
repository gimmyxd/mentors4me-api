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
    ActionMailer::Base.delivery_method = :smtp
    config.api_only = true
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.eager_load_paths += %W(#{config.root}/models)
    config.eager_load_paths += Dir["#{config.root}/models/**/"]

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

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Rack::Cors configuration
    config.middleware.insert_before 0, 'Rack::Cors', debug: true, logger: (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '/cors',
                 headers: :any,
                 methods: [:post],
                 credentials: true,
                 max_age: 0

        resource '*',
                 headers: :any,
                 methods: [:get, :post, :delete, :put, :patch, :options, :head],
                 max_age: 0
      end
    end
  end
end

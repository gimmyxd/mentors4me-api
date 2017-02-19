# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
if ENV['COVERAGE'] == 'on'
  require 'simplecov'
  require 'simplecov-rcov'
  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails' do
    add_group 'Models', 'app/models'
    add_group 'Controllers', 'app/controllers'
    add_group 'Abilities', 'app/abilities'
    # minimum_coverage 98
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'
require 'factory_girl'
require 'rake'

Rails.application.eager_load!

Rails.application.load_tasks
Rake::Task['generate_user_roles'].invoke

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.include Devise::Test::ControllerHelpers, type: :controller

  # database_cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation, except: %w(roles)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
  end

  config.before(:all) do
    FactoryGirl.reload
  end

  # warnings deprecation
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before :each, type: :controller do
    stub_request(:post, 'https://api.sendgrid.com/v3/mail/send')
      .to_return(status: 200, body: '', headers: {})
  end

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
  include UsefulHelper
end

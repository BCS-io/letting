require 'spec_helper'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
Capybara::Screenshot.prune_strategy = :keep_last_run

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome

require 'elasticsearch/extensions/test/cluster/tasks'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include AuthMacros
  config.include CapybaraHelper

  #
  # Create an elasticserach test cluster before a test run.
  #
  config.before :all, elasticsearch: true do
    Elasticsearch::Extensions::Test::Cluster.start(nodes: 1, port: 9200) \
      unless Elasticsearch::Extensions::Test::Cluster.running?
  end

  #
  # Destroy an elasticserach test-cluster at the end of a test run.
  #
  config.after :suite do
    Elasticsearch::Extensions::Test::Cluster.stop(nodes: 1, port: 9200) \
      if Elasticsearch::Extensions::Test::Cluster.running?
  end

  config.include FontAwesome::Rails::IconHelper
end

require 'capybara/rspec'
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  config.before(:each, type: :system, selenium_chrome: true) do
    driven_by :selenium_chrome
  end
end

# rails has a take_screenshot but cannot get it working
Capybara::Screenshot.prune_strategy = :keep_last_run

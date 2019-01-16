require 'capybara/rspec'
require 'capybara-screenshot/rspec'
Capybara::Screenshot.prune_strategy = :keep_last_run

# Capybara.register_driver :selenium_chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end

# Capybara.register_driver :headless_chrome do |app|
#   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
#     chromeOptions: { args: %w[headless disable-gpu] }
#   )

#   Capybara::Selenium::Driver.new app,
#                                  browser: :chrome,
#                                  desired_capabilities: capabilities
# end

Capybara.javascript_driver = :headless_chrome


RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
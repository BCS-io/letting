#
# Database Cleaner
#
# http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
#
# 1. Add database_cleaner to Gemfile:
#
# group :test do
#   gem 'database_cleaner'
# end
#
# 2. IMPORTANT! change to false "config.use_transactional_fixtures = false" line
#    in spec/rails_helper.rb.
#
# 3. Create a file containing the following in spec/support/database_cleaner.rb:
#
RSpec.configure do |config|
  # Before the entire test suite runs, clear the test database out completely.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Rails.application.load_seed  # optional
  end

  # sets the default database cleaning strategy to be transactions.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Runs only before examples which have been flagged :js => true.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # Hook up database_cleaner around the beginning and end of each test, telling
  # it to execute whatever cleanup strategy we selected beforehand.
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

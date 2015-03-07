#
# Gemfile
#
# Keeping a Gemfile up to date and especially updated Gems with security issues
# is an important maintenance task.
#
# 1) Which Gems are out of date?
# 2) Versioning
# 3) Importance of a Gem to the Application
# 4) Breaking Gem List
#
#
# 1) Which Gems are out of date?
#
# bundle outdated  or use https://gemnasium.com/BCS-io/letting
#
# Update a single Gem using bundle update < gem name >
# - example of pg: bundle update gp
#
# If a gem has not changed check what restrictions are present
# Taking pg as an example again. We can update to 0.18.1, 0.18.2, 0.18.3
# but not update to 0.19.1. To update to 0.19.1 you need to change statement
#
# gem 'pg', '~>0.18.0'     =>      gem 'pg', '~>0.19.0'
#
# After updating a gem run rake though and if it passes before pushing up.
#
# 2) Versioning
#
# Most Gems follow Semantic Versioning:  http://semver.org/
#
# Risk of causing a problem:
# Low: 0.18.0 => 0.18.X        - bug fixes
# Low-Medium: 0.18.0 => 0.19.0 - New functionality but should not break old
#                                functionality.
# High:       0.18 = > 1.0.0   - Breaking changes with past code.
#
# 3) Importance of a Gem to the Application
#
# Gems which are within development will not affect the production application:
#
#  group :development do
#    gem 'better_errors', '~> 2.1.0'
#  end
#
# Gems without a block will affect the production application and you should be
# more careful with the update.
#
#
# 4) Breaking Gem List
#
# There are a number of Gems that if you update you break the build.
# Keep a list of them here - details why next to the gem inclusion below:
#
# gem 'capybara-webkit',  '~>1.3.0'
# gem 'database_cleaner', '~> 1.3.0'
# gem 'rake', '10.1.0'
#
#
source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# configuration - needs to be at the top!
gem 'dotenv-rails', '~> 1.0.0'
gem 'dotenv-deployment', '~> 0.2.0'

# Use postgresql as the database for Active Record
gem 'pg', '~>0.18.0'

gem 'equalizer'

# Use SCSS for style-sheets
gem 'sass-rails', '~> 5.0.1'
gem 'sprockets', '~>2.12.3'
gem 'autoprefixer-rails', '~> 5.1.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.0'

# Latest ui (5.0.3) causes CapybaraHelper to fail
gem 'jquery-ui-rails', '~> 4.1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2.0'

# Must be include before elasticsearch
gem 'kaminari', '~> 0.16.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.9'

# font icon
gem 'font-awesome-rails'
gem 'rails-env-favicon'

# Search Gems
gem 'elasticsearch', '~> 1.0.6'
gem 'elasticsearch-model', '~> 0.1.6'
gem 'elasticsearch-rails', '~> 0.1.6'
# Create es test node
gem 'elasticsearch-extensions', group: :test

# Use Unicorn as the app server
gem 'unicorn', '~> 4.8.0'

# corner banner on staging environment
gem 'rack-dev-mark', '~> 0.7.0'

gem 'whenever', require: false

gem 'seedbank'

group :development do
  gem 'better_errors', '~> 2.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'brakeman', '~>3.0.0', require: false
  gem 'bullet', '~>4.14.0'
  gem 'rails_best_practices', '~>1.15.0'
  gem 'rubocop', '~> 0.29.0', require: false
  gem 'rubycritic', require: false
  gem 'traceroute'
  gem 'scss-lint'
end

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '~> 3.3.0'
  gem 'capistrano-bundler', '~> 1.1.3'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.0'
  gem 'capistrano-postgresql', '~> 2.0.0'
  gem 'capistrano-unicorn-nginx', github: 'BCS-io/capistrano-unicorn-nginx'
  gem 'capistrano-rails-collection', '~> 0.0.3'
  gem 'capistrano-db-tasks', require: false
  gem 'mascherano', '~> 1.1.0'
end

group :development, :test do
  gem 'capybara', '~> 2.4.0'
  #
  # BREAKING GEM
  # Capybara-webkit 1.4.1 causes 2 errors (maybe worth investigating why)
  #
  gem 'capybara-webkit', '~>1.3.0'
  gem 'capybara-screenshot'
  # 0.1.1 seems to introduce errors - Use this gem occasionally to weed out
  # performance errors with tests
  # gem 'capybara-slow_finder_errors', '0.1.0'
  gem 'selenium-webdriver', '~>2.45.0'
  gem 'pry-rails', '~>0.3.0'
  gem 'rb-readline'
  gem 'pry-stack_explorer', '~>0.4.9.0'
  gem 'byebug', '~> 3.5.0'
  gem 'rack-mini-profiler', '~>0.9.0'
  gem 'rspec-rails', '~> 3.2.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'table_print'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'zonebie'
end

group :test do
  gem 'coveralls', '~>0.7.0', require: false

  #
  # BREAKING GEM
  # v1.4.0 cleans the 'schema_migrations'
  # https://github.com/DatabaseCleaner/database_cleaner/issues/317
  # Do not upgrade until there is a fix  version > 1.4.0
  #
  gem 'database_cleaner', '~> 1.3.0'
  gem 'timecop', '~>0.7.0'
end

# BREAKING GEM
# rake versions after this break args options code in
# import rake (used for setting range and test user logins)
# TODO: fix for being able to read in args
# Using this version of the gem because it is the same as on production system
gem 'rake', '10.1.0'

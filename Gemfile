#
# Gemfile
#
# Keeping a Gemfile up to date and especially updated Gems with security issues
# is an important maintenance task.
#
# 1) Which Gems are out of date?
# 2) Update a Gem
# 3) Gemfile.lock
# 4) Versioning
# 5) Importance of a Gem to the Application
# 6) Resetting Gems back to the original version
# 7) Breaking Gem List
#
#
# 1) Which Gems are out of date?
#
# bundle outdated  or use https://gemnasium.com/BCS-io/letting
#
#
# 2) Update a Gem
#
#  Update a single Gem using bundle update < gem name >
#    - example of pg: bundle update gp
#
# If a gem has not changed check what restrictions the Gemfile specifies
# Taking pg as an example again. We can update to 0.18.1, 0.18.2, 0.18.3
# but not update to 0.19.1. To update to 0.19.1 you need to change the Gem
# statement in this file and then run bundle update as above.
#
# gem 'pg', '~>0.18.0'     =>      gem 'pg', '~>0.19.0'
#
# After updating a gem run rake though and if it passes before pushing up.
#
#
# 3) Gemfile.lock
#
# You should never change Gemfile.lock directly. By changing Gemfile and
# running bundle commands you change Gemfile.lock indirectly.
#
#
# 4) Versioning
#
# Most Gems follow Semantic Versioning:  http://semver.org/
#
# Risk of causing a problem:
# Low: 0.18.0 => 0.18.X        - bug fixes
# Low-Medium: 0.18.0 => 0.19.0 - New functionality but should not break old
#                                functionality.
# High:       0.18 = > 1.0.0   - Breaking changes with past code.
#
#
# 5) Importance of a Gem to the Application
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
# 6) Resetting Gems back to the original version
#
# If you need to return your Gems to original version.
# a) git checkout .
# b) bundle install
#

#
# GEMS THAT BREAK THE BUILD
#
# A list of Gems that if updated will break the application.
#
# Gem                     Using      Last tested   Gem Bug
# Capistrano              3.5.0            3.6.0         Y
# capistrano-db-tasks       0.3              0.4         Y
# jquery-ui-rails         4.1.2            5.0.3         N
# rake                   10.1.0           11.2.2         ?
#
#
source 'https://rubygems.org'
ruby '~> 2.5.0'

#
# Production
#
gem 'autoprefixer-rails', '~> 9.4.0'
gem 'bcrypt', '~> 3.1.12'
gem 'coffee-rails', '~> 4.2.0'
gem 'elasticsearch', '~> 5.0.0'
gem 'elasticsearch-model', '~> 5.0.0'
gem 'elasticsearch-rails', '~> 5.0.0'
gem 'equalizer'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.7.0'
gem 'jquery-rails', '~> 4.3.0'

# BREAKING GEM
# 5.0.3 - causes CapybaraHelper to fail
gem 'jquery-ui-rails', '4.1.2'

# Kaminari before elasticsearch
gem 'kaminari', '~> 1.1.0'
gem 'lograge'
gem 'nokogiri', '>= 1.8.2' # to avoid vulnerability
gem 'pg', '~>0.20.0' # rails 5 required to use pg 1.0+
gem 'rack-dev-mark', '~> 0.7.0' # corner banner on staging environment
gem 'rails', '4.2.11'
gem 'rails-env-favicon'

# BREAKING GEM
# rake versions after this break args options code in import rake (used for
# setting range and test user logins).
# TODO: fix for being able to read in args
# Using this version of the gem because it is the same as on production system
gem 'rake', '10.1.0'
gem 'sass-rails', '~> 5.0.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'seedbank'
gem 'sprockets', '~>3.7.0'
gem 'turbolinks', '~> 2.5.0'
gem 'uglifier', '~> 2.7.0'
gem 'unicorn', '~> 4.8.0'
gem 'whenever', require: false

# Capistrano deployment
#
group :development do
  # rake has to be ver 11 - bug in 3.6.0
  gem 'capistrano', '~> 3.5.0', require: false

  gem 'airbrussh', '~> 1.1.0', require: false
  gem 'capistrano-bundler', '~> 1.1.3', require: false

  #
  # Upgrading to 0.4.0 caused
  # createdb: database creation failed: ERROR:  permission denied to create
  gem 'capistrano-db-tasks', '0.3', require: false
  gem 'capistrano-postgresql', '~> 4.2.0', require: false
  gem 'capistrano-rails', '~> 1.1.3', require: false
  gem 'capistrano-rails-collection', '~> 0.0.3', require: false
  gem 'capistrano-rails-console', '~> 1.0.0', require: false
  gem 'capistrano-secrets-yml', '~> 1.0.0', require: false
  gem 'capistrano-unicorn-nginx', git: 'https://github.com/BCS-io/capistrano-unicorn-nginx.git', require: false
end

#
# Development only
#
group :development do
  gem 'better_errors', '~> 2.5.0'
  gem 'binding_of_caller', '~> 0.8.0'
  gem 'brakeman', '~>4.3.0', require: false
  gem 'bullet', '~>5.9.0'
  gem 'rails_best_practices', '~>1.15.0'
  gem 'require_all', '~> 1.0' # 2.0 seems to break rails_best_practice
  # Remove to avoid vulnerability
  gem 'rubocop', '~> 0.62.0', require: false
  gem 'rubycritic', require: false
  gem 'scss_lint', '~> 0.57.0', require: false
  gem 'traceroute'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

#
# Development and testing
#
group :development, :test do
  #
  # BREAKING GEM
  # Throwing exceptions when it hits breakpoints
  #
  gem 'bundler-audit'
  gem 'byebug', platform: :mri
  gem 'capybara', '~> 2.13.0'

  gem 'capybara-screenshot', '~> 1.0.0'
  gem 'capybara-webkit', '~> 1.15.0'
  gem 'chromedriver-helper', '~> 2.1.0'
  # 0.1.1 seems to introduce errors - Use this gem occasionally to weed out
  # performance errors with tests
  # gem 'capybara-slow_finder_errors', '0.1.0'
  gem 'meta_request'
  gem 'pry-rails', '~>0.3.0'
  gem 'pry-stack_explorer', '~>0.4.9.0'
  gem 'rack-mini-profiler', '~>1.0.0'
  gem 'rb-readline'
  gem 'rspec-rails', '~> 3.8.0'
  gem 'selenium-webdriver', '~>3.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'table_print'
  gem 'zonebie', '~> 0.6.0'
end

#
# Testing
#
group :test do
  gem 'database_cleaner', '~> 1.5.0'

  # Create e.s. test node
  gem 'elasticsearch-extensions'
  gem 'timecop', '~>0.8.0'
end

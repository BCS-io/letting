source 'https://rubygems.org'
ruby '2.1.1'

# Configuration of sensitive information
gem 'dotenv-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Use postgresql as the database for Active Record
gem 'pg', '~>0.17.0'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'
gem 'sprockets', '~>2.11.0' # bugfix 3376e59
gem 'autoprefixer-rails'
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.4.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 4.1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0.2'

gem 'kaminari', '~> 0.15.1'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn', '~> 4.8.0'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', '2.15.4'
  gem 'capistrano-rbenv'
end

group :development, :test do
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller'
  gem 'bullet', '~>4.7.1'
  gem 'capybara', '~> 2.2.0'
  gem 'capybara-webkit', '~>1.1.0'
  gem 'guard'
  gem 'guard-rspec', '~> 3.0.2'
  gem 'guard-livereload'
  gem 'launchy', '~> 2.4.2'
  gem 'pry-rails', '~>0.3.2'
  gem 'rb-readline'
  gem 'pry-nav', '~>0.2.3'
  gem 'pry-stack_explorer', '~>0.4.9.0'
  gem 'rack-mini-profiler', '~>0.9.0'
  gem 'rspec-rails', '~> 2.14.0'
end

group :development do
  gem 'brakeman', '~>2.4.0', require: false
  gem 'rails_best_practices', '~>1.15.1'
end

group :test do
  gem 'zeus'
  gem 'simplecov', '~>0.8.2', require: false
  gem 'coveralls', '~>0.7.0', require: false
  gem 'database_cleaner', '~> 1.2.0'
  gem 'timecop', '~>0.7.0'
end

group :test do
  gem 'rake', '10.1.0'
end

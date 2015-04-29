# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/postgresql'
require 'capistrano/unicorn_nginx'
# rails rake tasks
require 'capistrano/rails/collection'
require 'capistrano-db-tasks'
# manage dotenv
require 'mascherano/env'
require 'airbrussh/capistrano'
require 'whenever/capistrano'
require 'capistrano/rails/console'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }

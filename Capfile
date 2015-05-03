require 'airbrussh/capistrano'
# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'capistrano-db-tasks'
require 'capistrano/postgresql'
require 'capistrano/rails'
require 'capistrano/rails/console'
require 'capistrano/rbenv'
require 'capistrano/rails/collection'
require 'capistrano/unicorn_nginx'
require 'mascherano/env' # manage dotenv
require 'whenever/capistrano'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }

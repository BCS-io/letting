# Capistrano Main Gem
require 'capistrano/deploy'
require 'capistrano/setup'

#
# Capistrano gems
#
require 'airbrussh/capistrano'
require 'capistrano/backup'
require 'capistrano/bundler'
require 'capistrano-db-tasks'
require 'capistrano/postgresql'
require 'capistrano/rails'
require 'capistrano/rails/collection'
require 'capistrano/rails/console'
require 'capistrano/secrets_yml'
require 'capistrano/unicorn_nginx'
require 'whenever/capistrano'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/**/*.rake').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }

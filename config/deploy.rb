#
# Configuration File to Deploy Schedule Gardener
#
#   - Supplies general variables that Capistrano uses to deploy software
#   - Other files supply environment specific settings:
#       -  /config/deploy/production.rb
#          /config/deploy/staging.rb
#
#
#-------------------------------------------------------------------------------
#
# Capistrano Standard Application
#
lock '3.4.0'

set :application, 'letting'
set :user, 'deployer'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:full_app_name)}"

set :keep_releases, 3

set :default_env, {
  'PATH' => 'PATH=$PATH:~/.gem/ruby/2.2.0/bin'
}

#
# SCM
#
set :scm, :git
set :repo_url, 'git@github.com:BCS-io/letting.git'
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME']

#-------------------------------------------------------------------------------

#
# db-tasks (and assets) - sgruhier/capistrano-db-tasks
#
set :db_local_clean, true      # remove the local dump file after loading
set :db_remote_clean, true     # rm the dump file from the server after download

set :assets_dir, %w(public/assets public/att)
set :local_assets_dir, %w(public/assets public/att)

#
# Unicorn
#
set :unicorn_workers, 2

#
# capistrano-backup
#
set :backup_model_file, "#{fetch(:full_app_name)}.rb"

#
# Whenever a cron scheduler
#
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

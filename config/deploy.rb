lock '3.4.0'

#
# Application variables
#
set :application, 'letting'
set :user, 'deployer'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:full_app_name)}"

# SCM
set :scm, :git
set :repo_url, 'git@github.com:BCS-io/letting.git'
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME']

# rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.2.2'
set :rbenv_custom_path, '/opt/rbenv'

set :unicorn_workers, 2

set :tests, ['spec']

# house keeping
set :keep_releases, 3

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

#
# db-tasks (and assets)
# sgruhier/capistrano-db-tasks
#

# if you want to remove the local dump file after loading
set :db_local_clean, true

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# If you want to import assets, you can change
# default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/assets public/att)
set :local_assets_dir, %w(public/assets public/att)
# Whenever a cron scheduler

desc 'Invoke a rake command on the remote server'
task :invoke, [:command] => 'deploy:set_rails_env' do |_task, args|
  on primary(:app) do
    within current_path do
      with rails_env: fetch(:rails_env) do
        rake args[:command]
      end
    end
  end
end

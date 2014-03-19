#  Change
#  Avoid app names with - a pain with postgres
#  capify . and allow asset pipeline
#  :server_name
#  :application
#  unicorn in gemfile
require 'bundler/capistrano'
require 'capistrano-rbenv'

# set :whenever_command, "bundle exec whenever"
# require 'whenever/capistrano'

load 'config/recipes/base'
load 'config/recipes/nginx'
load 'config/recipes/unicorn'
load 'config/recipes/postgresql'
load 'config/recipes/seed'
load 'config/recipes/check'
load 'config/recipes/monit'
load 'config/recipes/upload'

set  :host, '193.183.99.251'
server "#{host}", :web, :app, :db, primary: true
set :server_name, 'letting.bcs.io'  # change

set :user, 'deployer'
set :application, 'letting'  # change
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository_owner, 'RichardWigley' # change
set :repository, "git@bitbucket.org:#{repository_owner}/#{application}.git"
set :branch, 'master'
set :keep_releases, 3
set :rbenv_ruby_version, '2.1.1'

set :maintenance_template_path,
    File.expand_path('../recipes/templates/maintenance.html.erb', __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases

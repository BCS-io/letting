# Production
#
# Capistrano environment settings
#
set :stage, :internet
set :branch, 'master'

# Simple Role Syntax
role :app, %w(deployer@bcs.io)
role :web, %w(deployer@bcs.io)
role :db,  %w(deployer@bcs.io)

# bcs.io
server 'bcs.io', user: 'deployer', roles: %w(web app db), primary: true

set :rails_env, :internet

set :nginx_server_name, 'letting.richardwigley.co.uk'

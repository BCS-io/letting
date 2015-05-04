###################################################
#                  STAGING                        #
###################################################
#
#-------------------------------------------------------------------------------
# Capistrano Standard environment settings
#
set :stage, :staging
set :branch, 'master'

role :app, %w(deployer@10.0.0.35)
role :web, %w(deployer@10.0.0.35)
role :db,  %w(deployer@10.0.0.35)

server '10.0.0.35', user: 'deployer', roles: %w(web app db), primary: true
set :rails_env, :staging

#-------------------------------------------------------------------------------

#
# Unicorn
#
set :nginx_server_name, 'letting-staging.local.bcs.io'

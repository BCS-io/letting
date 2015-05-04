###################################################
#                  PRODUCTION                     #
###################################################
#
#-------------------------------------------------------------------------------
# Capistrano Standard environment settings
#
set :stage, :production
set :branch, 'master'

role :app, %w(deployer@10.0.0.36)
role :web, %w(deployer@10.0.0.36)
role :db,  %w(deployer@10.0.0.36)

server '10.0.0.36', user: 'deployer', roles: %w(web app db), primary: true
set :rails_env, :production

#-------------------------------------------------------------------------------

#
# Unicorn
#
set :nginx_server_name, 'letting.local.bcs.io'

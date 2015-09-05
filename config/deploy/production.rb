###################################################
#                  PRODUCTION                     #
###################################################
#
#-------------------------------------------------------------------------------
# Capistrano Standard environment settings
#
set :stage, :production
set :branch, 'master'

role :app, %w(deployer@10.0.0.30)
role :web, %w(deployer@10.0.0.30)
role :db,  %w(deployer@10.0.0.30)

server '10.0.0.30', user: 'deployer', roles: %w(web app db), primary: true
set :rails_env, :production

#-------------------------------------------------------------------------------

#
# Unicorn
#
set :nginx_server_name, 'letting.adams.bcs.io'

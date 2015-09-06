###################################################
#                  PRODUCTION                     #
###################################################
#
#-------------------------------------------------------------------------------
# Capistrano Standard environment settings
#
def ip_address
  '10.0.0.30'
end

set :stage, :production
set :branch, 'master'

role :app, ip_address
role :web, ip_address
role :db,  ip_address

server ip_address, user: 'deployer', roles: %w(web app db), primary: true
set :rails_env, :production

#-------------------------------------------------------------------------------

#
# Unicorn
#
set :nginx_server_name, 'letting.adams.bcs.io'

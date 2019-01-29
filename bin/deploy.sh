#!/bin/bash

ADMIN="${ADMIN:-deployer}"
APP_ENV="${APP_ENV:-staging}"
APPLICATION="${APPLICATION:-letting}"
BACKUP_FILE="${BACKUP_FILE:-${APPLICATION}.dump}"
DATABASE="${DATABASE:-database}"
DOKKU_VERSION="${DOKKU_VERSION:-0.14.5}"
REMOTE_USER="${REMOTE_USER:-dokku}"
SERVER_IP="${SERVER_IP:-68.183.255.135}"
SERVER_NAME="${SERVER_NAME:-yell}"
SSH_ROOT="${SSH_ROOT:-root}"
WORKDIR="${WORKDIR:-deploy}"

export $(grep -v '^#' .env | xargs)

function preseed_staging() {
cat << EOF
STAGING SERVER (DIRECT VIRTUAL MACHINE) DIRECTIONS:
  1. Root needs to be able to login via ssh - if not:

     bin/deployer -O

  2. Server requires a static IP if not:

     bin/deploy -N 10.0.0.10 10
     or
     bin/deploy -N 192.168.2.10 192

  3. Run the commands in: $0 --help
     Example:
       ./deploy.sh -a
EOF
}

function backup_remote_database_now () {
  echo "database: ${DATABASE} Bucket: ${BUCKET_NAME} AWSID: ${AWS_ACCESS_KEY_ID} AWSKey: ${AWS_SECRET_ACCESS_KEY} CRON: ${CRON_SCHEDULE}"
  ssh ${REMOTE_USER}@${SERVER_IP} postgres:backup ${DATABASE} ${BUCKET_NAME}
  echo "done!"
}

function backup_local_database () {
  echo "Backing up local database for ${APPLICATION} to ${BACKUP_FILE}"
  pg_dump -Fc --no-acl --no-owner letting_development > "${WORKDIR}/backup_database/${BACKUP_FILE}"
  ls -l backup_database| grep ${BACKUP_FILE}
  echo "done!"
}

function clear_remote_host_identification () {
  echo "Configuring passwordless sudo..."
  ssh-keygen -q -R ${SERVER_IP}
  ssh-keygen -q -R ${SERVER_NAME}
  echo "done!"
}

# configure suders()
#   - rules under which you can run sudo command
#
function configure_sudoers () {
  echo "Configuring passwordless sudo..."
  scp "${WORKDIR}/sudo/sudoers" "${SSH_ROOT}@${SERVER_IP}:/tmp/sudoers"
  ssh -t "${SSH_ROOT}@${SERVER_IP}" bash -c "'
sudo chmod 440 /tmp/sudoers
sudo chown root:root /tmp/sudoers
sudo mv /tmp/sudoers /etc
  '"
  echo "done!"
}

function create_application () {
  echo "Create dokku application"
  ssh ${REMOTE_USER}@${SERVER_IP} apps:create ${APPLICATION}
  echo "done!"
}

function deploy_application () {
  echo "deployer application ${APPLICATION}"
  git push dokku master
  echo "done!"
}

function domain_set () {
  echo "domain set for ${APPLICATION}"
  ssh ${REMOTE_USER}@${SERVER_IP} domains:set ${APPLICATION} book-gardener.co.uk www.book-gardener.co.uk
  ssh ${REMOTE_USER}@${SERVER_IP} domains:report ${APPLICATION}
  echo "done!"
}

function firewall_configure () {
  echo "Configuring iptables firewall..."
  local WEB_ALLOWED_IPS=($PUBLIC_ADDRESS_1 $PUBLIC_ADDRESS_2 $PRIVATE_ADDRESS_1 $PRIVATE_ADDRESS_2)
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
    sudo ufw --force reset
    sudo ufw allow ssh
  '"

  for ips in "${WEB_ALLOWED_IPS[@]}"
  do
    ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
      sudo ufw allow from ${ips} to any port http
    '"
  done

  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
    sudo ufw deny http

    sudo ufw --force enable
    sudo ufw status verbose
  '"
  echo "done!"
}

function has_sudo () {
   ssh -T "${SSH_ROOT}@${SERVER_IP}" bash << EOF
    if sudo -n true
    then
      echo "sudo installed"
    else
      echo "No sudo!"
    fi
    echo "Suoders:"
    grep -Po '^sudo.+:\K.*$' /etc/group
EOF
  echo "done!"
}

function key_copy_to_remote_admin() {
  echo "Adding SSH key to ${ADMIN}..."
  sshpass -p ${ADMIN_PASSWORD} ssh-copy-id -i "${HOME}/.ssh/id_rsa.pub" ${ADMIN}@${SERVER_IP}
  echo "done!"
}

function key_copy_to_remote_root() {
  echo "Local public SSH key to remote root user"
  ssh-copy-id -i "${HOME}/.ssh/id_rsa.pub" ${SSH_ROOT}@${SERVER_IP}
  echo "done!"
}

function lockdown_ssh () {
  echo "locking down configuration of SSH..."
  scp "${WORKDIR}/ssh/sshd_config" "${ADMIN}@${SERVER_IP}:/tmp/sshd_config"
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
sudo chown root:root /tmp/sshd_config
sudo mv /tmp/sshd_config /etc/ssh
sudo systemctl restart ssh
  '"
  echo "done!"
}

function remote_database_import () {
  echo "copy backup then remote database import"
  scp "${WORKDIR}/backup_database/${BACKUP_FILE}" "${ADMIN}@${SERVER_IP}:/tmp/${BACKUP_FILE}"
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
    sudo dokku postgres:import ${DATABASE} < /tmp/${BACKUP_FILE}
  '"
  echo "done!"
}

function install_dokku () {
  echo "installing dokku v${1}"
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
wget -O "bootstrap.sh wget https://raw.githubusercontent.com/dokku/dokku/v${1}/bootstrap.sh"
sudo DOKKU_TAG=v${1} bash bootstrap.sh
dokku version
  '"
# dokku user must have the key copied this way or it doesn't work
cat ~/.ssh/id_rsa.pub | ssh ${ADMIN}@${SERVER_IP} "sudo sshcommand acl-add dokku dokku-admin"
  echo "done!"
}

function ssl_set () {
  echo "ssl set for domain"
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
  sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
  dokku config:set --no-restart ${APPLICATION} DOKKU_LETSENCRYPT_EMAIL=${DOKKU_LETSENCRYPT_EMAIL}
  dokku letsencrypt ${APPLICATION}
  dokku letsencrypt:cron-job --add
  dokku letsencrypt:ls
  '"
  echo "done!"
}

function open_in_browser () {
  echo "open app in browser"
  open http://${SERVER_IP}
  echo "done!"
}

function plugin_database () {
  echo "plugin dokku database"
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
if [ ! -e /var/lib/dokku/plugins/available/postgres ]; then
  sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
  sudo dokku postgres:create ${DATABASE}
  dokku postgres:link ${DATABASE} ${APPLICATION}
  dokku postgres:expose ${DATABASE}
  dokku postgres:backup-auth ${DATABASE} ${AWS_ACCESS_KEY_ID} ${AWS_SECRET_ACCESS_KEY} ${AWS_REGION}
  dokku postgres:backup-schedule ${DATABASE} \"7 3 * * 1-5\" ${BUCKET_NAME}
  dokku postgres:backup-schedule-cat ${DATABASE}
else
 echo "dokku postgres is already installed"
 dokku postgres:info ${DATABASE}
 echo "Backup schedule of ${DATABASE}:"
 dokku postgres:backup-schedule-cat ${DATABASE}
fi
  '"
  echo "done!"
}

function plugin_logging () {
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'
    sudo dokku plugin:install https://github.com/michaelshobbs/dokku-logspout.git
    sudo dokku plugin:install https://github.com/michaelshobbs/dokku-hostname.git dokku-hostname
    dokku logspout:server syslog+tls://logs7.papertrailapp.com:37515
    dokku logspout:stream
    dokku logspout:start
    dokku logspout:info
  '"
  echo "done!"
}

function plugin_elasticsearch () {
  echo "plugin dokku elasticsearch"
  ssh -t "${SSH_ROOT}@${SERVER_IP}" bash -c "'
dokku plugin:install https://github.com/dokku/dokku-elasticsearch.git elasticsearch
cd /var/lib/dokku/plugins/enabled/elasticsearch
git checkout -B fix_es6
git remote add sv https://github.com/slava-vishnyakov/dokku-elasticsearch.git
git pull sv es6_fix2
echo 'vm.max_map_count=262144' | tee -a /etc/sysctl.conf; sysctl -p
export ELASTICSEARCH_IMAGE_VERSION=6.5.4; dokku elasticsearch:create search
dokku elasticsearch:link search ${APPLICATION}
dokku run ${APPLICATION} rake elasticsearch:sync
  '"
  echo "done!"
}

function provision_server () {

  echo "---  -K  ---"
  key_copy_to_remote_root

  echo "---  -r  ---"
  admin_added

  echo "---  -k  ---"
  key_copy_to_remote_admin

  echo "---  -u  ---"
  configure_sudoers

  echo "---  -f  ---"
  firewall_configure

  echo "---  -l  ---"
  lockdown_ssh

  echo "---  -d  ---"
  install_dokku ${1}

  echo "---  -A  ---"
  create_application

  echo "---  -m  ---"
  domain_set

  echo "---  -L  ---"
  plugin_logging

  echo "---  -D  ---"
  plugin_database

  echo "---  -i  ---"
  remote_database_import

  echo "---  -P  ---"
  deploy_application

  echo "---  -e  ---"
  plugin_elasticsearch

  echo "---  -w  ---"
  open_in_browser

  echo "---  -U  ---"
  unattended_updates
}

function unattended_updates () {
  echo "Unattended updated configured"
  scp "${WORKDIR}/unattended-upgrades/50unattended-upgrades" "${ADMIN}@${SERVER_IP}:/tmp/50unattended-upgrades"
  scp "${WORKDIR}/unattended-upgrades/20auto-upgrades" "${ADMIN}@${SERVER_IP}:/tmp/20auto-upgrades"
  ssh -t "${ADMIN}@${SERVER_IP}" bash -c "'

sudo chmod 644 /tmp/50unattended-upgrades /tmp/20auto-upgrades
sudo chown root:root /tmp/50unattended-upgrades /tmp/20auto-upgrades
sudo mv /tmp/50unattended-upgrades /tmp/20auto-upgrades  /etc/apt/apt.conf.d/
systemctl list-timers apt-daily.timer
  '"
  echo "done!"
}

function admin_added () {
  echo "Add admin user: ${ADMIN}"
  ssh -t "${SSH_ROOT}@${SERVER_IP}" bash -c "'
id -u ${ADMIN} &>/dev/null || adduser --quiet  --disabled-password  --shell /bin/bash --gecos \"\" ${ADMIN}
adduser ${ADMIN} sudo
echo \"${ADMIN}:${ADMIN_PASSWORD}\" | sudo chpasswd
echo \"Test user present:\"
cut -d: -f1 /etc/passwd | grep ${ADMIN}
  '"
  echo "done!"
}

function server_reachable () {
  ping ${SERVER_IP}
}

function help_menu () {
cat << EOF
Usage: ${0} (-A | -a | -B | -b | -D | -d | -e | -h | -i | -K | -k | -l | -m | -o | -P | -p | -R | -r | -S | -s | -U | -u | -w)

ENVIRONMENT VARIABLES:
   APP_ENV          Environment that is being deployed to, 'staging' or 'production'
                    Defaulting to ${APP_ENV}

   APPLICATION      Name of the application

   BACKUP_FILE      File name of database backup

   DATABASE         Name of the database plugin. Defaulting to ${DATABASE}

   DOKKU_VERSION    Dokku version to install. Defaulting to ${DOKKU_VERSION}

   REMOTE_USER      User being created for remote work

   SERVER_IP        IP address to work on, ie. staging or production
                    Defaulting to ${SERVER_IP}

   SERVER_NAME      Name of server to work on, Defaulting to yell (but nothing better)

   SSH_ROOT         root User account to bootstrap provision of server


OPTIONS:
   -A|--app                  Create application
   -a|--all                  Provision everything for base server
   -B|--backup-remote-now    Backup remote database now, once
   -b|--backup-database      Backup local database to file
   -D|--database             Install Database plugin for Dokku
   -d|--dokku                Install Dokku
   -e|--elasticsearch        Elasticsearch plugin installed for Dokku
   -f|--firewall             Firewall via UFW
   -h|--help                 Show this message
   -i|--import-database      Restore remote database from local backup copy
   -K|--key-root             Root Key - local key copied to remote for passwordless ssh for root
   -k|--ssh-key              Admin Key - local key copied to remote for passwordless ssh for admin
   -l|--lockdown-ssh         Secure SSH configuration
   -m|--domain-added         Domain added to the application
   -o|--has-sudo             Sudo installed on the remote server?
   -P|--deploy               Deploy application to dokku
   -p|--ping                 Ping the server
   -r|--user-added           User added to the system
   -R|--remove               Removes all keys belonging to hostname from a known_hosts file
   -U|--unattended-updates   Unattended Security Updates added
   -u|--sudo                 Configure passwordless sudo
   -r|--user-added           User added to the remote server
   -S|--preseed-staging      Preseed intructions for the server
   -s|--ssl-set              SSL via let's encrypt for the application
   -U|--unattended           Unattended security updates configured
   -u|--sudo                 Passwordless sudo in sudoers:
   -w|--open-web             Open application in browser

EXAMPLES:
   Create application:
        $ deploy -A

   Provision everything for base server:
        $ deploy -a

   Backup remote database now, once:
        $ deploy -B

   Backup local database to file:
        $ deploy -b

   Install Database Dokku plugin
        $ deploy -D

   Install Dokku v${DOKKU_VERSION}:
        $ deploy -d 0.14.2

   Elasticsearch plugin installed for Dokku:
        $ deploy -e

   Firewall via UFW:
        $ deploy -f

   Displays help:
        $ deploy -h

   Restore remote database from local backup copy:
        $ deploy -i

   Root Key - local key copied to remote for passwordless ssh for root:
        $ deploy -K

   Admin Key - local key copied to remote for passwordless ssh for admin:
        $ deploy -k

   Secure ssh configuration:
        $ deploy -l

   Domain added to the application:
        $ deploy -m

   Sudo installed on the remote server?
        $ deploy -o

   Deploy application to Dokku:
        $ deploy -P

   Ping the server:
        $ deploy -p

   Removes all keys belonging to hostname from a known_hosts file:
        $ deploy -R

   User added to the remote server:
        $ deploy -r

   Preseed intructions for the server:
        $ deploy -S

   SSL via let's encrypt for the application:
        $ deploy -s

   Unattended security updates configured:
        $ deploy -U

   Passwordless sudo in sudoers:
        $ deploy -u

   Open application in browser:
        $ deploy -w
EOF
}

while [[ $# > 0 ]]
do
case "${1}" in
  -A|--application)
  create_application
  shift
  ;;
  -a|--all)
  provision_server "${2:-${DOKKU_VERSION}}"
  shift
  ;;
  -B|--backup-remote-now)
  backup_remote_database_now
  shift
  ;;
  -b|--backup)
  backup_local_database
  shift
  ;;
  -D|--database)
  plugin_database
  shift
  ;;
  -d|--dokku)
  install_dokku "${2:-${DOKKU_VERSION}}"
  shift
  ;;
  -e|--elasticsearch)
  plugin_elasticsearch
  shift
  ;;
  -f|--firewall)
  firewall_configure
  shift
  ;;
  -h|--help)
  help_menu
  shift
  ;;
  -i|--import-database)
  remote_database_import
  shift
  ;;
  -K|--key-root)
  key_copy_to_remote_root
  shift
  ;;
  -k|--ssh-key)
  key_copy_to_remote_admin
  shift
  ;;
  -L|--paper-trail-logging)
  plugin_logging
  shift
  ;;
  -l|--lockdown-ssh)
  lockdown_ssh
  shift
  ;;
  -o|--has-sudo)
  has_sudo
  shift
  ;;
  -m|--domain-added)
  domain_set
  shift
  ;;
  -p|--ping)
  server_reachable
  shift
  ;;
  -P|--deploy-application)
  deploy_application
  shift
  ;;
  -R|--remove-keys)
  clear_remote_host_identification
  shift
  ;;
  -r|--admin-user-added)
  admin_added
  shift
  ;;
  -S|--preseed-staging)
  preseed_staging
  shift
  ;;
  -s|--ssl_set)
  ssl_set
  shift
  ;;
  -U|--unattended)
  unattended_updates
  shift
  ;;
  -u|--sudo)
  configure_sudoers
  shift
  ;;
  -w|--open-web)
  open_in_browser
  shift
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  ;;
esac
shift
done

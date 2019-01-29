#!/bin/bash

ADMIN="${ADMIN:-deployer}"
APP_ENV="${APP_ENV:-staging}"
APPLICATION="${APPLICATION:-letting}"
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
Usage: ${0} (-a | -h | -S)

ENVIRONMENT VARIABLES:
   APP_ENV          Environment that is being deployed to, 'staging' or 'production'
                    Defaulting to ${APP_ENV}

   SERVER_IP        IP address to work on, ie. staging or production
                    Defaulting to ${SERVER_IP}

   SERVER_NAME      Name of server to work on, Defaulting to yell (but nothing better)

OPTIONS:
   -a|--all                  Provision everything except preseeding
   -h|--help                 Show this message
   -S|--preseed-staging      Preseed intructions for the staging server

EXAMPLES:
   Configure everything together:
        $ deploy -a

   Displays help
        $ deploy -h

   Displays help for to pre-seed the server for provisioning
        $ deploy -S

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
  -d|--dokku)
  install_dokku "${2:-${DOKKU_VERSION}}"
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
  -K|--key-root)
  key_copy_to_remote_root
  shift
  ;;
  -k|--ssh-key)
  key_copy_to_remote_admin
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
  -u|--sudo)
  configure_sudoers
  shift
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  ;;
esac
shift
done

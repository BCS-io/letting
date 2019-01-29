#!/bin/bash

ADMIN="${ADMIN:-deployer}"
APP_ENV="${APP_ENV:-staging}"
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

function key_copy_to_remote_root() {
  echo "Local public SSH key to remote root user"
  ssh-copy-id -i "${HOME}/.ssh/id_rsa.pub" ${SSH_ROOT}@${SERVER_IP}
  echo "done!"
}

function provision_server () {

  echo "---  -K  ---"
  key_copy_to_remote_root

  echo "---  -r  ---"
  admin_added
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
  -a|--all)
  provision_server
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
  -o|--has-sudo)
  has_sudo
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
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  ;;
esac
shift
done

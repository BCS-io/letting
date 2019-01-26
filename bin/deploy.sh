#!/bin/bash


APP_ENV="${APP_ENV:-staging}"
REMOTE_USER="${REMOTE_USER:-deployer}"
WORKDIR="${WORKDIR:-deploy}"

export $(grep -v '^#' .env | xargs)

function preseed_staging() {
cat << EOF
STAGING SERVER (DIRECT VIRTUAL MACHINE) DIRECTIONS:
  1. Configure a static IP address directly on the VM
     su
     <enter password>
     nano /etc/network/interfaces
     [change the last line to look like this, remember to set the correct
      gateway for your router's IP address if it's not 192.168.1.1]
iface eth0 inet static
  address ${SERVER_IP}
  netmask 255.255.255.0
  gateway 192.168.1.1

  3. Install sudo (If missing)
     apt-get update && apt-get install -y -q sudo

  4. Add the remote user to the sudo group on the remote server
       - where ${REMOTE_USER} is the provisioning user's name
     $ adduser ${REMOTE_USER} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
     $ adduser ${REMOTE_USER} sudo
     verify: sudo grep -Po '^sudo.+:\K.*$' /etc/group

  5. Run the commands in: $0 --help
     Example:
       ./deploy.sh -a
EOF
}

function provision_server () {
  echo "add code here"
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

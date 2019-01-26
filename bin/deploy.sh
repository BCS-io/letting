#!/bin/bash


APP_ENV="${APP_ENV:-staging}"
REMOTE_USER="${REMOTE_USER:-dokku}"
SERVER_IP="${SERVER_IP:-68.183.255.135}"
SERVER_NAME="${SERVER_NAME:-yell}"
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

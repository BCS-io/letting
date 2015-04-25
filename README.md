[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)
[![Dependency Status](https://gemnasium.com/BCS-io/letting.png)](https://gemnasium.com/BCS-io/letting)

###LETTING

Letting is an application for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges. It handles a number of properties with ground rents, services, and other charges.

This document covers the following sections

####Content
1. Project Setup
  * 1\. Development Setup
  * 2\. Server Setup
    * 1\. Install Ubuntu Linux 14.04 LTS
    * 2\. Deploy the Software stack using Chef
    * 3\. Deploy the application
2. Commands
  * 1\. rake db:import
3. Monitoring
  * 1\. Monit
4. Cheatsheet
  * 1\. QEMU
    * 1\. Basic Commands
    * 2\. Removing an instance from
  * 2\. SSH
  * 3\. Firewalls
    * 1\. Listing Firewall
    * 2\. Adding Ranges to the firewall
    * 3\. Disabling the Firewall
  * 4\. Chef
    * 1\. Updating a cookbook
    * 2\. Updating a server
  * 5\. Ruby
    * 1\. Updating Ruby Build
  * 6\. Postgresql
  * 7\. Elasticsearch
5. Troubleshooting - docs/trouble_shooting.md
  * 1\. Net::SSH::HostKeyMismatch
  * 2\. How to fix duplicate source.list entry
  * 3\. Capistrano
    * 1\. Capistrano failing to deploy - with github.com port-22
  * 3\. Missing secret_key_base
  * 4\. Running Rake Tasks on Production Server
  * 5\. Cleaning Production Setup
  * 6\. Reset the database
  * 7\. Running rails console in production
  * 8\. Truncating a file without changing ownership
  *.9\. Recursive diff of two directories
6. Production Client
<br><br><br>

===

###1. PROJECT SETUP

####1.1. Development Setup

1. `git clone git@github.com:BCS-io/letting.git`

2. `sudo apt-get install libqt4-dev libqtwebkit-dev -y`
  * Capybara-webkit requirement

3. `bundle install --verbose`
  * this can take a while and verbose gives feedback.

4. `rake db:create`
5. `git clone git@bitbucket.org:bcsltd/letting_import_data.git  ~/code/letting/import_data`
    * Clone the *private* data repository into the import_data directory
    * Can be imported into the database

6. Create .env file - for *private* application data - not kept in the repository
  * 1\. `cp ~/code/letting/.env.example  .env`
  * 2\. `rake secret`  and copy the generated key into .env

7. `rake db:reboot`
  * drops the database (if any), creates and runs migrations.
  * Repeat each time you want to delete and restore the database.

8. Elasticsearch (chef configures this)
  * 1\. Configure Elasticsearch memory limit (a memory greedy application)
    `sudo nano /usr/local/etc/elasticsearch/elasticsearch-env.sh`
    1. Change: ES_HEAP_SIZE=1503m  => ES_HEAP_SIZE=1g, -Xms1g, -Xmx1g
    2. Change: ES_JAVA_OPS => -Xms1500m - Xmx1500m =>  -Xms1g -Xmx1g
  * 2\. `sudo service elasticsearch restart`
    * verify as it also says 'ok' when it fails.   `sudo service elasticsearch restart`
    * Not unusual pid file (see Elasticsearch configuration below)

9. Add Data - using *one* of:
  * 1\. Seed data: `rake db:seed`
  * 2\. import data: `rake db:import -- -t`
    * -t includes test user and passwords.
  * 3\. Pull data from server: `cap <environment> db:pull`

10. `rake elasticsearch:sync`
  * Re-index Elasticsearch
<br><br>

####1.2. Server Setup

1. Install Ubuntu Linux 14.04 LTS

2. Provision the software stack with Chef
  * change to a machine configured for Chef Solo
  * 1\. `cd ~/code/chef/repo`
  * 2\. `knife solo bootstrap root@example.com'
    * 1\. Once complete reboot box before webserver working
    * 2\. Once System set up use `knife solo cook deployer@example.com' for further updates.
  * 3\. `ssh deployer@example.com`
    * Verify you can passwordlessly log on.

3. Deploy the application with Capistrano
  * 1\. `cap <environment> setup`
  * 2\. `cap <environment> env:upload`
    * 1\. .env file uploaded to shared directory
  * 3\. `cap <environment> deploy`

4. Add Data
    On your *local* system Add Data (see 1.1.9 above). Then copy to the server.
    `cap <environment> db:push`
    or use fake data `cap <environment> rails:rake:db:seed`

5. `cap <environment> 'invoke[elasticsearch:sync]'`
  * Import Data Into Elasticsearch Indexes



My Reference: Webserver alias: `ssh arran`
<br><br><br>

===

###2. COMMANDS

####2.1. rake db:import
  `rake db:import` is a command for importing production data from the old system to the new system.

  The basic command: `rake db:import`

#####options
  To add an option -- is needed after db:import to bypass the rake argument parsing.
  1. -r Range of properties to import: `rake db:import -- -r 1-200`
    * Default is import all properties
  2. -t Adding test passwords for easy login: `rake db:import -- -t`
    * 1\. Default is *no* test passwords
    * 2\. Import creates an admin from the application.yml's user and password (see above).
  3. -h Help displays help and exits `rake db:import -- -h`
<br>

===

###3 Monitoring

#####3.1 Monit

Monit connection: http://<ip-address>:2812
* Connection Must be from BCS Network
* Connection Uses the ['monit']['web_interface'] user/password as defined in letting-<environment>
<br><br><br>

#####3.2 Logstash

Logstash is available - listing the messages recorded in monitored system's
logs. Navigate to the server with a browser. See http://logstash.net/

===

###4 Cheatsheet
* See [docs/cheat_sheet.md](https://github.com/BCS-io/letting/blob/master/docs/cheat_sheet.md)

===

###5 Trouble Shooting
* See [docs/trouble_shooting.md](https://github.com/BCS-io/letting/blob/master/docs/trouble_shooting.md)

===

###6 Production Client
On release of the version go through the [production checklist](https://github.com/BCS-io/letting/blob/master/docs/production_checklist.md)

===
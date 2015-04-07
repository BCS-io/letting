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
  * 5\. Postgresql
  * 6\. Elasticsearch
5. Troubleshooting
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
<br><br><br>

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

#####4.1 QEMU

######4.1.1 Basic Commands

````
virsh list --all     -  List running virtual servers

virsh reboot <vm-name>  - restarts the virtual server
virsh shutdown <vm-name> - quit of virtual server
virsh destroy <vm-name> - forced quit of virtual server

virsh start <vm-name> - start guest
````

######4.1.2 Displaying Logical Volume

`lvdisplay -v /dev/<volume-group-name>`
* `lvdisplay -v /dev/fla2014-vg`

######4.1.3 Removing an instance from

Removing an instance called <vm-name>

`````
  virsh destroy <vm-name>

  lvremove /dev/<volume-group-name>/<vm-name> -f
    * lvremove /dev/fla-2014/papa -f

  virsh undefine <vm-name>
  rm -rf /var/lib/libvirt/images/<vm-name>
  sudo reboot - otherwise temporary files prevent you from reusing the vm name
`````

######4.1.4 Creating an instance from

Removing an instance called <vm-name>

`````
  sudo su
  mkdir -p /var/lib/libvirt/images/<vm-name>
  nano builder_script
  Insert builder script (Scripts saved in repository: bcs-network under: /configs/vm)
  chmod +x builder_script
`````

Creating the diskspace - 7GB Root(/), 3GB Swap, 9GB /var

````
cat > vmbuilder.partition  <<EOF
root 7000
swap 3000
/var 9000
EOF
````

Run the builder script

`./builder_script`

Edit the product of the builder script

`nano /etc/libvirt/qemu/<vm-name>.xml`

Changing

1. Driver from 'qcow2' to 'raw'
  * Before
    `<driver name='qemu' type='qcow2'/>`
  * After
    `<driver name='qemu' type='raw'/>`

2. source file from qcow's to vm-name
  * Before
    * `<source file='/var/lib/libvirt/images/scarp/ubuntu-kvm/tmpd6ojfe.qcow2'/>`
  * After
    * `<source file='/dev/<volume-group-name>/<vm-name>'>`
      * Example: `<source file='/dev/fla2014-vg/scarp'>`


Create the logical volume

`lvcreate -L 20G --name <vm-name> <volume-group-name>`
 1. `lvcreate -L 20G --name scarp fla2014-vg`

Conversion

`qemu­-img convert /var/lib/libvirt/images/<vm-name>/ubuntu-kvm/tmp???????.qcow2 ­-O raw /dev/<volume-group-name>/<vm-name>`

Configuration
`virsh autostart <vm-name>`
`virsh start <vm-name>`

Verify
`ping 10.0.0.X`
`ssh deployer@10.0.0.x`
  `ping 8.8.8.8`

===


####4.2 SSH

1. brew install ssh-copy-id
2. ssh-copy-id deployer@example.com
3. ssh deployer@example.com  (verify)

####4.3 Firewall

#####4.3.1 Listing Firewall

`sudo iptables --list`

#####4.3.2 Adding Ranges to the wall

1. ssh to the server which is having packets blocked.
2. What address is being blocked? `cat /var/log/kern.log`
  1. The logs contains blocked ip packets - to summarize the import things. DST is the ip address of the server we have been blocked to getting and DPT is the port number. We want to allow this combination through.
  Mar 13 ... iptables denied: IN= OUT=eth0 ... DST=23.23.181.189 ... DPT=443
3. What range does the blocked ip address belong to?
  1. Install whois if not already installed
  2. whois 23.23.181.189
  3. Add the CIDR range to the firewall, in this case Amazon's 23.20.0.0/14

#####4.3.3 Disabling the Firewall

If an operation is not completing and you suspect a firewall issue
these commands completely remove it. (Rebooting the box, if applicable, restores the firewall)

````
    sudo su
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -F
````

#####4.4 Chef

######4.4.1 Updating a cookbook

1. Clone the cookbook to the local machine under ~/code/chef/
2. Make changes to the cookbook increment the version in the meta data and commit and push back.
3. Under the repo directory update the reference `berks update <cookbook-name>`
  1. Confirm the version number has changed to the one you used in 2.
4. Update the cookbook by revendoring `berks vendor ./cookbooks/`
5. Apply the cookbook again: `knife solo bootstrap deployer@example.com`
  1. Don't bother around 5 - 11 pm in the evening as you get failed to connect.


######4.4.2 Updating a server

Chef is installed on servers - I've seen this get out of date. Removing it and then doing a knife solo bootstrap puts on a later version. Running chef on existing server may have firewall problems.

1. Confirm situation: `dpkg --list | grep chef` and `sudo find / -name chef`
2. Remove package: `sudo apt-get purge chef`
3. Run chef again: `knife solo bootstrap root@example.com`
4. Step 1 confirm situation.


#####4.5 Postgresql
1. change to Postgres user and open psql prompt `sudo -u postgres psql postgres`
2. Listing Users (roles) and attributes: `\du`
3. Listing all databases: `\list`
4. Connect to a database: `\c db_name`
5. Execute SQL file:  `psql -f thefile.sql letting_<envionrment>`
6. Logging In: `psql -d letting_<envionment> -U letting_<environment>`

#####4.6 Elasticsearch

* Java application that improves usability of Lucene. [1]
* Recommend giving half of heap to Elasticsearch - Lucene will use the rest. [2]

1. Configuration
  Init script: `/etc/init.d/elasticsearch` sets
    1. Set pid:  PIDFILE='/usr/local/var/run/<server-name>.pid'
      * Mention this as it is inconsistent with normal conventions
    2. Set ENV: ES_INCLUDE='/usr/local/etc/elasticsearch/elasticsearch-env.sh'

  1. Directory: ES_HOME/config: /usr/local/etc/elasticsearch/
    1. JVM Configuration: elasticsearch-env.sh
      * ES_HEAP_SIZE - to half of the available memory
      * `ES_HEAP_SIZE=1g`
      I also move ES_JAVA_OPTS to 1000m to keep consistency with the default configuration.
      ES_JAVA_OPTS="...
                   -Xms1000m
                   -Xmx1000m
                   ...
                   "
      See further reading [3] on memory Q and A.

    2. Settings: elasticsearch.yml

  Once changes made: `sudo service elasticsearch restart`


2. Forced Re-index:   `rake elasticsearch:sync` <br>
3. Find Cluster name: `curl -XGET 'http://localhost:9200/_nodes'`  <br>
4. Document Mapping:  `curl -XGET "localhost:9200/development_properties/_mapping?pretty=true"`  <br>
5. Find All indexes:   `curl -XGET "localhost:9200/_stats/indices?pretty=true"`  <br>
                       example: development_properties<br>
6. Index Structure:    `curl -XGET 'http://127.0.0.1:9200/my_index/_mapping?pretty=1'` <br>
7. Return Records:     `curl -XGET "localhost:9200/my_index/_search?pretty=true"`  <br>
8. 'Simple' Query

````
    GET development_properties/_search
    {
       "query": {
          "match": {
              "_all": {
                  "query": "35 Beau",
                  "operator": "and"
              }
          }
       }
    }
````

When Elasticsearch Breaks the build during testing:

````
   Failure/Error: Client.import force: true, refresh: true
       Faraday::ConnectionFailed:
         Connection refused - connect(2) for "localhost" port 9200
````

Reset Elasticsearch

````
sudo service elasticsearch restart
````

Somtimes it won't delete the Elasticsearch pid file.

````
    Stopping elasticsearch...PID file found, but no matching process running?
    Removing PID file...
    rm: cannot remove ‘/usr/local/var/run/10_0_0_101.pid’: Permission denied

    To Remove
    sudo rm /usr/local/var/run/10_0_0_101.pid

    Repeat Restart

````

Further Reading

[1] http://exploringelasticsearch.com/overview.html
[2] http://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html
[3] http://zapone.org/benito/2015/01/21/elasticsearch-reports-default-heap-memory-size-after-setting-environment-variable/
<br><br><br>
===

###5. TROUBLESHOOTING

####5.1 Net::SSH::HostKeyMismatch

Error seen as something like:

fingerprint d2:82:b0:34:3c:df etc does not match for "193.183.99.251" Copy the workstation public key to the server.

Problem:
Computers keep a unique identifier of servers they have connected with so that they can prevent a bad actor pretending they are that server. However, sometimes the ID of the server changes in which case you need to reset the server.

Solution

`ssh-keygen -R <ip address> | <name>`


####5.2 How to fix duplicate source.list entry

Format of Repository Source List found in `/etc/apt/sources.list` and `/etc/apt/sources.list.d/`
`<type of repository>  <location>  <dist-name> <components>`

Example
`deb http://archive.ubuntu.com/ubuntu precise main`


Example of a duplicate
* In the example 'universe' has been duplicated

````
deb http://archive.ubuntu.com/ubuntu precise universe
deb http://archive.ubuntu.com/ubuntu precise main universe
````

* Fix - this is equivalent
````
deb http://archive.ubuntu.com/ubuntu precise main universe
````

Further Reading
http://askubuntu.com/questions/120621/how-to-fix-duplicate-sources-list-entry


####5.8 Capistrano

####1. SSH Doctor

Diagnostic tool

````
cap production ssh:doctor
````

````
The agent has no identities.
````

####2. Capistrano failing to deploy - with github.com port-22

Occasionally a deployment fails with an unable to connect to github.
Any network service is not completely reliable. Wait for a while and try again.

````
DEBUG [44051a0f]  ssh: connect to host github.com port 22: Connection timed out
DEBUG [44051a0f]  fatal: Could not read from remote repository.
````



####5.3 Missing secret_key_base

Without the secret_key being set - nothing works 2 diagnostics:
1. cat unicorn.stderr.log - app error: Missing `secret_key_base` ... set this value in `config/secrets.yml
2. current/.env is missing
3. Do not add the file into version control, git.

Solution

1. run `rake secret` and copy the output
2. Create a .env file in the root of the project
3. Add SECRET_KEY_BASE:  and copy the output from 1.
4. `cap production env:upload`
5. Restart the server - another deployment did this otherwise `sudo service unicorn_<name of process> reload` worth trying.


####5.4 Running Rake Tasks on Production Server

  `ssh <server>`
  `cd ~/apps/letting_<environment>/current`
  ` RAILS_ENV=<environment> bundle exec rake <method name>`


####5.5. Cleaning Production Setup

1. `sudo rm -rf ~/apps/`
2. `sudo rm /tmp/unicorn.letting_*.sock`
3. `sudo -u postgres psql`
4. `postgres=# drop database letting_<environment>;`
  1. if you have outstanding backend connections:
    `SELECT pid FROM pg_stat_activity where pid <> pg_backend_pid();`
    Then for each connection:
    `SELECT pg_terminate_backend($1);`
5. Start Server Setup

===


####5.6. Reset the database
Sometimes when you are changing a project the database will not allow you to delete it due to open connections to it. If you cannot close the connections you will have to reset the database. If this is the case follow this:

1. `cap production rails:rake:db:drop`
2. If database will not be dropped - Remove any backend connections
  1. local dev: `rake db:terminate RAILS_ENV=test`
  2. Production: *need a cap version*
3. `cap <environment> deploy`
  1. Should see the migrations being run.
4. `cap <environment> db:push`
  1. The data has been deleted by the drop this puts it back.

####5.7 Running rails console in production
`bundle exec rails c production`


####5.8 Truncating a file without changing ownership

````
cat /dev/null > /file/you/want/to/wipe-out
`````

####5.9 Recursive diff of two directories

````
diff -r letting/ letting_diffable/ | sed '/Binary\ files\ /d' >outputfile
````

####6 Production Client
On release of the version go through the checklist in docs/production_checklist
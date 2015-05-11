[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Coverage Status](https://coveralls.io/repos/BCS-io/letting/badge.png)](https://coveralls.io/r/BCS-io/letting)
[![Dependency Status](https://gemnasium.com/BCS-io/letting.png)](https://gemnasium.com/BCS-io/letting)

# LETTING

Letting is an application for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges. It handles a number of properties with ground rents, services, and other charges.

This document covers the following sections

####Content
1. [Project Setup](#project-setup)
  * 1\. Development Setup
  * 2\. Server Setup
    * 1\. Install Ubuntu Linux 14.04 LTS
    * 2\. Deploy the Software stack using Chef
    * 3\. Deploy the application
2. [Commands](#commands)
  * 1\. rake db:import
3. [Monitoring](#monitoring)
  * 1\. [Monit](#monit)
  * 2\. [Logstash](#logstash)

4. [Cheatsheet](#cheatsheet)
  * 1\. [Chef](#chef)
    * 1\. Running A Script on a machine for the first time
    * 2\. Updating a cookbook
    * 3\. Updating a server
    *.4\. Adding on a new cookbook to a recipe
  * 2\. [Cron](#cron)
  * 3\. [Elasticsearch](#elasticsearch)
  * 4\. [Firewall](#firewall)
    * 1\. [Listing Rules](#firewall-listing-rules)
    * 2\. [Adding Ranges](#firewall-adding-ranges)
    * 3\. [Disabling](#firewall-disabling)
  * 5\. [Postgresql](#postgresql)
  * 6\. [QEMU](#qemu)
    * 1\. Basic Commands
    * 2\. Removing an instance from
  * 7\. [Ruby](#ruby)
    * 1\. Updating Ruby
  * 8\. [SSH](#ssh)
  
5. [Troubleshooting](#troubleshooting)
  * 1\. [Net::SSH::HostKeyMismatch](#net-ssh-hostkeymismatch)
  * 2\. [How to fix duplicate source.list entry](#how-to-fix-duplicate-source-list-entry)
  * 3\. [Capistrano](#capistrano)
    * 1\. SSH Doctor
    * 2\. Capistrano failing to deploy - with github.com port-22
  * 4\. [Cron](#cron)
  * 5\. [Missing secret_key_base](#missing-secret_key_base)
  * 6\. [NGINX](#nginx)
  * 7\. [Production Server](#production-server)
    * 1\. [Clean application](#clean-application)
    * 2\. [Database reset](#database-reset)
    * 3\. [Rails console](#rails-console)
    * 4\. [Rake Tasks](#rake-tasks)
  * 8\. [Truncating a file without changing ownership](#truncating-a-file-without-changing-ownership)
  * 9\. [Recursive diff of two directories](#recursive-diff-of-two-directories)
6. Production Client
<br><br><br>





##1. PROJECT SETUP<a name='project-setup'></a>

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

6. Create secret file - for *private* application data - not kept in the repository
  * 1\. `cp ~/code/letting/config/secrets.example.yml  secrets.yml`
  * 2\. `rake secret`  and copy the generated keys into secrets.yml

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




##2. COMMANDS<a name='commands'></a>

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

  
  
  
  
##3 Monitoring<a name='monitoring'></a>

#####3.1 Monit<a name='monit'></a>

* `monit status` - current situation  
* `sudo service monit reload` - if config files have been updated

Monit connection: http://<ip-address>:2812
* Connection Must be from BCS Network - a firewall blocks every other address
* Connection Uses the ['monit']['web_interface'] user/password as defined in letting-<environment>
<br><br>

#####3.2 Logstash<a name='logstash'></a>

Logstash is available - listing the messages recorded in monitored system's
logs. Navigate to the server with a browser. See http://logstash.net/




##4 Cheatsheet<a name='cheatsheet'></a>

#####4.1 Chef<a name='chef'></a>

######4.1.1 Running A Script on a machine for the first time

1. `ssh-copy-id deployer@example.com`
  * confirm ssh in without any password
2. `knife solo bootstrap deployer@<name|ipaddress>`
3. Requires you to respond to password many times and takes 

######4.1.2 Updating a cookbook

1. Clone the cookbook to the local machine under ~/code/chef/
2. Make changes to the cookbook increment the version in the meta data and commit and push back.
3. Under the repo directory update the reference `berks update <cookbook-name>`
  1. Confirm the version number has changed to the one you used in 2.
4. Update the cookbook by revendoring `berks vendor ./cookbooks/`
5. Apply the cookbook again: `knife solo bootstrap deployer@example.com`
  1. Don't bother around 5 - 11 pm in the evening as you get failed to connect.


######4.1.3 Updating a server

Chef is installed on servers - I've seen this get out of date. Removing it and then doing a knife solo bootstrap puts on a later version. Running chef on existing server may have firewall problems.

1. Confirm situation: `dpkg --list | grep chef` and `sudo find / -name chef`
2. Remove package: `sudo apt-get purge chef`
3. Run chef again: `knife solo bootstrap root@example.com`
4. Step 1 confirm situation.


######4.1.4 Adding on a new cookbook to a recipe
1. Create a new cookbook - take note of the name in the metadata
2. Use the name in
  * repo berksfile `cookbook '<name>' github: 'BCS-io-provision/<name>-cookbook'`
  * metadata `depends '<name>'`
3. Call the recipe in the dependent cookbook `<name>::<my-recipe>`

##### 4.2 Cron<a name='cron'></a>

###### Information
`man cron and man crontab` - introduction to the files used by cron and how to run cron

###### Basic Commands
`pgrep cron` - cron daemon running
`crontab -l` - lists the crontab for the current user, `-u` to set the user
`cat /var/log/syslog | grep CRON` - cron outputs into syslog when it runs

###### Files
1. `cat /etc/crontab` 
  * system wide crontab
  * runs the files in cron.daily, cron.weekly, and cron.monthly
  * must be executable (have a * by the name of the file in directory ll)
2. `ls /etc/cron*`
  * lists the scripts to be run under the system wide cron table.
3. `# ls /var/spool/cron/*`
  * list user contabs
4. `# cat /var/spool/cron/*/*`
  * lists the user scripts

* Cron user scripts will be under 'deployer'
* run does not execute jobs which have a dot in their name
  - One of the VPS's have a file name name `apt.disabled`  


##### 4.3 Elasticsearch<a name='elasticsearch'></a>

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

######Further Reading

[1] http://exploringelasticsearch.com/overview.html  
[2] http://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html  
[3] http://zapone.org/benito/2015/01/21/elasticsearch-reports-default-heap-memory-size-after-setting-environment-variable/  


####4.4 Firewall<a name='firewall'></a>

###### 4.4.1 Listing Rules<a name='firewall-listing-rules'></a>

`sudo iptables --list`

###### 4.4.2 Adding Ranges<a name='firewall-adding-ranges'></a>

1. ssh to the server which is having packets blocked.
2. What address is being blocked? `cat /var/log/kern.log`
  1. The logs contains blocked ip packets - to summarize the import things. DST is the ip address of the server we have been blocked to getting and DPT is the port number. We want to allow this combination through.
  Mar 13 ... iptables denied: IN= OUT=eth0 ... DST=23.23.181.189 ... DPT=443
3. What range does the blocked ip address belong to?
  1. Install whois if not already installed
  2. whois 23.23.181.189
  3. Add the CIDR range to the firewall, in this case Amazon's 23.20.0.0/14

###### 4.4.3 Disabling<a name='firewall-disabling'></a>

If an operation is not completing and you suspect a firewall issue
these commands completely remove it. (Rebooting the box, if applicable, restores the firewall)

````
    sudo su
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -F
````

##### 4.5 Postgresql<a name='postgresql'></a>
1. change to Postgres user and open psql prompt `sudo -u postgres psql postgres`
2. Listing Users (roles) and attributes: `\du`
3. Listing all databases: `\list`
4. Connect to a database: `\c db_name`
5. Execute SQL file:  `psql -f thefile.sql letting_<envionrment>`
6. Logging In: `psql -d letting_<envionment> -U letting_<environment>`



##### 4.6 QEMU<a name='qemu'></a>

Source files on host: `/var/lib/libvirt/images/`

###### 4.6.1 Basic Commands

````
virsh list --all     -  List running virtual servers

virsh suspend <vm-name> - Pause a virtual server
virsh Resume <vm-name> - Restore a suspended virtual server

virsh reboot <vm-name>  - restarts the virtual server
virsh shutdown <vm-name> - quit of virtual server
virsh destroy <vm-name> - forced quit of virtual server

virsh start <vm-name> - start guest
````

###### 4.6.2 Displaying Logical Volume

`lvdisplay -v /dev/<volume-group-name>`
* `lvdisplay -v /dev/fla2014-vg`

###### 4.6.3 Removing an instance from

Removing an instance called <vm-name>

`````
  virsh destroy <vm-name>

  lvremove /dev/<volume-group-name>/<vm-name> -f
    * lvremove /dev/fla-2014-vg/papa -f

  virsh undefine <vm-name>
  rm -rf /var/lib/libvirt/images/<vm-name>
  sudo reboot - otherwise temporary files prevent you from reusing the vm name
`````

###### 4.6.4 Creating an instance from

`````
  sudo su
  mkdir -p /var/lib/libvirt/images/<vm-name>
  cd /var/lib/libvirt/images/<vm-name>
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

Run the builder script (10mins+)

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
* `ping 10.0.0.X`
* `ssh deployer@10.0.0.x`
* `ping 8.8.8.8`

* Now, apply Chef script

===



#####4.7 Ruby<a name='ruby'></a>

1. Updating Ruby

  * Ruby Build does not know about the newest Ruby versions unless you update it.

  ````
  cd ~/.rbenv
  git pull
  cd plugins/ruby-build
  git pull
  ````

  * Applications need these changes to support a new Ruby
    * Gemfile `ruby '2.2.2'`
    * .ruby-version `2.2.2`
    * config/deploy  `set :rbenv_ruby, '2.2.2'`
    * `gem install bundler`
    * `bundle install`
    * `cap <environment> setup`  - updates unicorn
    * `cap <environment> deploy`


####4.8 SSH<a name='ssh'></a>

1. brew install ssh-copy-id
2. ssh-copy-id deployer@example.com
3. ssh deployer@example.com  (verify)  




## 5 Trouble Shooting<a name='troubleshooting'></a>


####5.1 Net::SSH::HostKeyMismatch<a name='net-ssh-hostkeymismatch'></a>

Error seen as something like:

fingerprint d2:82:b0:34:3c:df etc does not match for "193.183.99.251" Copy the workstation public key to the server.

Problem:
Computers keep a unique identifier of servers they have connected with so that they can prevent a bad actor pretending they are that server. However, sometimes the ID of the server changes in which case you need to reset the server.

Solution

`ssh-keygen -R <ip address> | <name>`


####5.2 How to fix duplicate source.list entry<a name='how-to-fix-duplicate-source-list-entry'></a>

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


####5.3 Capistrano<a name='capistrano'></a>

#####1. SSH Doctor

Diagnostic tool

````
cap production ssh:doctor
````

````
The agent has no identities.
````

#####2. Fail with github.com port-22

Occasionally a deployment fails with an unable to connect to github.
Any network service is not completely reliable. Wait for a while and try again.

````
DEBUG [44051a0f]  ssh: connect to host github.com port 22: Connection timed out
DEBUG [44051a0f]  fatal: Could not read from remote repository.
````

#####3. Fail with Unicorn not restarting

````
DEBUG [e912b64e]  /etc/init.d/unicorn_letting_staging: line 26: kill: (4370) - No such process
DEBUG [ee25176c]  Couldn't reload, starting 'export HOME; true /home/deployer ; cd /home/letting_staging/current && ( RBENV_ROOT=/opt/rbenv/ RBENV_VERSION=2.2.2 /opt/rbenv//bin/rbenv exec bundle exec unicorn -D -c /home/letting_staging/shared/config/unicorn.rb -E staging )' instead
DEBUG [69e7a669]  master failed to start, check stderr log for details
````

* Investigate: 
  - `sudo service letting_<environment> status`
  - `sudo service letting_<environment> reload`
  - `tail -80 ~/apps/letting_staging/shared/logs/unicorn.stderr.log`
    * `Address already in use  - connect(2) for /tmp/unicorn.letting_staging.sock (Errno::EADDRINUSE)`
* Remove: `# rm tmp/unicorn.chic_staging.sock`

#### 5.4 Cron<a name='cron'></a>

1. Is Cron running? `ps uww -C cron`
2. Has Cron run?  check syslog:  `tail -200 /var/log/syslog`

#### 5.5 Missing secret_key_base<a name='missing-secret_key_base'></a>

Without the secret_key being set - nothing works 2 diagnostics:

1. `cat unicorn.stderr.log` - app error: Missing `secret_key_base` ... set this value in `config/secrets.yml
2. current/.env is missing
3. Do not add the file into version control, git.

Solution

1. run `rake secret` and copy the output
2. Create a .env file in the root of the project
3. Add SECRET_KEY_BASE:  and copy the output from 1.
4. `cap production env:upload`
5. Restart the server - another deployment did this otherwise `sudo service unicorn_<name of process> reload` worth trying.


#### 5.6 NGINX<a name='nginx'></a>

`Reload nginx configuration nginx [fail]`
  * `sudo nginx -t`  - test configuration and exit
    * without the sudo you are running nginx as standard user and you get permission problems.
    * gives an error if the <application>/shared/log directory is missing

####5.7 Production Server<a name='production-server'></a>

1. Clean application<a name='clean-application'></a>

  1\. `sudo rm -rf ~/apps/`  
  2\. `sudo rm /tmp/unicorn.letting_*.sock`  
  3\. `sudo -u postgres psql`  
  4\. `postgres=# drop database letting_<environment>;`  
    * if you have outstanding backend connections:  
      `SELECT pid FROM pg_stat_activity where pid <> pg_backend_pid();`  
      Then for each connection:  
      `SELECT pg_terminate_backend($1);`  

  5\. Start Server Setup  


2. Database reset<a name='database-reset'></a>

  1\. `cap production rails:rake:db:drop`  
  2\. If database will not be dropped - Remove any backend connections  
    * 1\. local dev: `rake db:terminate RAILS_ENV=test`  
    * 2\. Production: *need a cap version*  

  3\. `cap <environment> deploy`  
    * Should see the migrations being run.  

  4\. `cap <environment> db:push`  
    * The data has been deleted by the drop this puts it back.  


3. Rails console<a name='rails-console'></a>
`bundle exec rails c production`


4. Rake Tasks<a name='rake-tasks'></a>

  ````
  ssh <server>
  cd ~/apps/letting_<environment>/current
  RAILS_ENV=<environment> bundle exec rake <method name>
  ````

5. Reload Service

  1\. `cat /var/log/syslog` => 'letting_unicorn' process is not running  
  2\. `sudo service unicorn_letting_production reload`  
    * Couldn't reload, starting ' error message continued and included the problem 
  


####5.8 Truncating a file without changing ownership<a name='truncating-a-file-without-changing-ownership'></a>

````
cat /dev/null > /file/you/want/to/wipe-out
`````

####5.9 Recursive diff of two directories<a name='recursive-diff-of-two-directories'></a>

````
diff -r letting/ letting_diffable/ | sed '/Binary\ files\ /d' >outputfile
````


===

###6 Production Client
On release of the version go through the [production checklist](https://github.com/BCS-io/letting/blob/master/docs/production_checklist.md)

===
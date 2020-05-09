[![Code Climate](https://codeclimate.com/github/BCS-io/letting.png)](https://codeclimate.com/github/BCS-io/letting)
[![Build Status](https://travis-ci.org/BCS-io/letting.png)](https://travis-ci.org/BCS-io/letting)
[![Dependency Status](https://gemnasium.com/BCS-io/letting.png)](https://gemnasium.com/BCS-io/letting)

# LETTING

Letting is an application for handling the accounts of a letting agency company in particular to print letters for people with unpaid charges. It handles a number of properties with ground rents, services, and other charges.

This document covers the following sections

#### Content

1. [Project Setup](#project-setup)

- 1\. Development Setup
- 2\. Server Setup
  - 1\. Provision
  - 2\. Deployment
    - 1\. [Code Setup](#deployment-code-setup)
    - 2\. Data

4. [Cheatsheet](#cheatsheet)

- 1\. [Cron](#cron)
- 2\. [Elasticsearch](#elasticsearch)
- 3j\. [Firewall](#firewall)
  - 1\. [Listing Rules](#firewall-listing-rules)
  - 2\. [What is being blocked?](#firewall-what-is being blocked)
  - 3\. [Adding Ranges](#firewall-adding-ranges)
  - 4\. [Disabling](#firewall-disabling)
  - 5\. [Enabling](#firewall-enabling)
- 4\. [Postgresql](#postgresql)
  - 1\.[Login](#postgresql-login)
  - 2\.[psql prompt](#postgresql-psql-prompt)
  - 3\.[Execute SQL](#postgresql-execute-sql)
  - 4\.[Verify](#postgresql-verify)
- 5\. [Ruby](#ruby)
- 6\. [SCP](#scp)
- 7\. [SSH](#ssh)

5. [Troubleshooting](#troubleshooting)

- 1\. [Net::SSH::HostKeyMismatch](#net-ssh-hostkeymismatch)
- 2\. [How to fix duplicate source.list entry](#how-to-fix-duplicate-source-list-entry)
- 5\. [Cron](#cron)
- 6\. [Elasticsearch Faraday::ConnectionFailed](#elasticsearch-connection-failed)
- 7\. [Truncating a file without changing ownership](#truncating-a-file-without-changing-ownership)
- 8\. [Recursive diff of two directories](#recursive-diff-of-two-directories)

6. Production Client
   <br><br><br>

## 1. PROJECT SETUP<a name='project-setup'></a>

### 1.1. Development Setup

1. `git clone git@github.com:BCS-io/letting.git`

2. `sudo apt-get install libqt4-dev libqtwebkit-dev -y`

- Capybara-webkit requirement

3. `bundle install --verbose`

- this can take a while and verbose gives feedback.

4. `rake db:create`

5. Create secret file - for _private_ application data - not kept in the repository

- 1\. `cp ~/code/letting/config/secrets.example.yml secrets.yml`
- 2\. `rake secret` and copy the generated keys into secrets.yml

6. `rake db:reboot`

- drops the database (if any), creates and runs migrations.
- Repeat each time you want to delete and restore the database.

7. Elasticsearch

- 1a\. Foreground
  - brew install elasticsearch 6.5.4
  - Open tab and enter `elasticsearch`
- 1b\. Background

  - Can also run elasticsearch as service
  - 'Reboot' instance with `sudo service elasticsearch restart`
  - Verify as it also says 'ok' when it fails. `sudo service elasticsearch restart`
  - Not unusual pid file (see Elasticsearch configuration below)

- 2\. Either Foreground or background Elasticsearch node will be discovered immediately.

- 3\. Configure Elasticsearch memory limit (a memory greedy application)
  - (chef configures this)
  - `sudo nano /usr/local/etc/elasticsearch/elasticsearch-env.sh`
  - Change: ES_HEAP_SIZE=1503m => ES_HEAP_SIZE=1g, -Xms1g, -Xmx1g
  - Change: ES_JAVA_OPS => -Xms1500m - Xmx1500m => -Xms1g -Xmx1g

8. Add test Data:

- 1\. Seed data: `rake db:seed`

9. `rake elasticsearch:sync`

- Re-index Elasticsearch
  <br><br>

### 1.2. Server Setup

#### 1.2.1. Provision

- Provisioning is a one time setup of the server which will then be ready for deployment. If another application is already deployed this will have been done.

1. Install Ubuntu-18.04 LTS x86_64-minimal
2. `ssh-keygen -R <server-name | server ip>`

- removes any previous keys that will prevent keyless ssh-ing.

3. For cloud services use Terraform
  - 1\. `cd to project`
  - 2\. `sudo bin/run`
    - follow instructions
    - Any ip address change should be used to update the DNS

4. Download latest version of the database
  - 1\. Download
  - 2\. Untar (apple allows you to double click)
  - 3\. Move the untarred file `export` to `letting/ansible/roles/dokku/files`

5. Run ansible over the server
  - 1\. Update ansible-galaxy - if needed / missing `bin/ansible-galaxy-requirements`
  - 2\. `bin/ansible-playbook`
     - errors will be present because deploy hasn't happened
       - test elasticsearch exists
       - test elasticsearch linkage?
       - application tag exists?
       - dokuu_bot.ansible_dokku : start dokku-daemon
     - follow instructions

6. Deploy application
  - 1\. `bin/gp`

6. Rerun ansible to provision server
  - 1\. `bin/ansible-playbook`
    - should pass without error

#### 1.2.2. Data

1. Database
  The database will be imported as part of the Ansible script. However, if you only want to import the database:
    -  `bin/ansible-playbook -t database`  
        - Backup database should be kept at the location specified in Amazon variable: `postgres_backup_file`

2. Elasticsearch
  Elasticsearch synchronises with the postgres database. To force this you can use the ansible instruction: 
    `bin/ansible-playbook -t elasticsearch`

<br>

## 4 Cheatsheet<a name='cheatsheet'></a>

### 4.1 Cron<a name='cron'></a>

#### Information

`man cron and man crontab` - introduction to the files used by cron and how to run cron

#### Basic Commands

`pgrep cron` - cron daemon running
`crontab -l` - lists the crontab for the current user, `-u` to set the user
`cat account_hide_monotonous_account_details` - show the raw cron command

- Example for a user: `crontab -u deployer -l`
  `cat /var/log/syslog | grep CRON` - cron outputs into syslog when it runs

#### Files

1. `cat /etc/crontab`

- system wide crontab
- runs the files in cron.daily, cron.weekly, and cron.monthly
- must be executable (have a \* by the name of the file in directory ll)

2. `ls /etc/cron*`

- lists the scripts to be run under the system wide cron table.

3. `# ls /var/spool/cron/*`

- list user contabs

4. `# cat /var/spool/cron/*/*`

- lists the user scripts

- Cron user scripts will be under 'deployer'
- run does not execute jobs which have a dot in their name
  - One of the VPS's have a file name name `apt.disabled`

### 4.2 Elasticsearch<a name='elasticsearch'></a>

- Java application that improves usability of Lucene. [1]
- Recommend giving half of heap to Elasticsearch - Lucene will use the rest. [2]

1. Configuration
   Init script: `/etc/init.d/elasticsearch` sets

   1. Set pid: PIDFILE='/usr/local/var/run/<server-name>.pid'
      - Mention this as it is inconsistent with normal conventions
   2. Set ENV: ES_INCLUDE='/usr/local/etc/elasticsearch/elasticsearch-env.sh'

1. Directory: ES_HOME/config: /usr/local/etc/elasticsearch/
   1. JVM Configuration: elasticsearch-env.sh
   - ES_HEAP_SIZE - to half of the available memory
   - `ES_HEAP_SIZE=1g`
     I also move ES_JAVA_OPTS to 1000m to keep consistency with the default configuration.
     ES_JAVA_OPTS="...
     -Xms1000m
     -Xmx1000m
     ...
     "
     See further reading [3] on memory Q and A.


    2. Settings: elasticsearch.yml

Once changes made: `sudo service elasticsearch restart`

2. Forced Re-index: `rake elasticsearch:sync` <br>
3. Find Cluster name: `curl -XGET 'http://localhost:9200/_nodes'` <br>
4. Document Mapping: `curl -XGET "localhost:9200/development_properties/_mapping?pretty=true"` <br>
5. Find All indexes: `curl -XGET "localhost:9200/_stats/indices?pretty=true"` <br>
   example: development_properties<br>
6. Return Records: `curl -XGET "localhost:9200/my_index/_search?pretty=true"` <br>
7. 'Simple' Query

```
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
```

#### Further Reading

[1] http://exploringelasticsearch.com/overview.html  
[2] http://www.elastic.co/guide/en/elasticsearch/guide/current/heap-sizing.html  
[3] http://zapone.org/benito/2015/01/21/elasticsearch-reports-default-heap-memory-size-after-setting-environment-variable/

### 4.3 Firewall<a name='firewall'></a>

#### 4.3.1 Listing Rules<a name='firewall-listing-rules'></a>

`sudo iptables --list`

#### 4.3.2 What is being blocked?<a name='firewall-what-is being blocked'></a>

#### Firewall blocks

1. ssh to the server which is having packets blocked.
2. What address is being blocked? `cat /var/log/kern.log`
3. The logs contains blocked ip packets - to summarize the import things. DST is the ip address of the server we have been blocked to getting and DPT is the port number. We want to allow this combination through.
   Mar 13 ... iptables denied: IN= OUT=eth0 ... DST=23.23.181.189 ... DPT=443

FQDN to ip address (Fully Qualified Domain Name)

`dig <domain-name>`

- Answer section - check the A records for ip addresses

#### 4.3.3 Adding Ranges<a name='firewall-adding-ranges'></a>

1. From ip address

- What range does the blocked ip address belong to?

1. Install whois if not already installed
2. whois 23.23.181.189
3. Add the CIDR range to the firewall, in this case Amazon's 23.20.0.0/14

#### 4.3.4 Disabling<a name='firewall-disabling'></a>

If an operation is not completing and you suspect a firewall issue
these commands completely remove it.

```
    sudo su
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -F
```

#### 4.4.5 Enabling<a name='firewall-enabling'></a>

`sudo iptables-restore /etc/iptables-rules`

- Rebooting the box, if applicable, will also restore the firewall

### 4.4 Postgresql<a name='postgresql'></a>

#### 4.4.1 Login<a name='postgresql-login'></a>

Server: `psql -U postgres`  
 Database: `psql -d letting_<envionment> -U letting_<environment>`

#### 4.4.2 psql prompt<a name='postgresql-psql-prompt'></a>

- Listing Users (roles) and attributes: `\du`
- Listing all databases: `\list`
- Connect to a database: `\c db_name`

#### 4.4.3 Execute SQL <a name='postgresql-prompt'></a>

- Execute SQL file: `psql -f thefile.sql letting_<environment>`

#### 4.4.4 Verify<a name='postgresql-verify'></a>

- brew info postgres - general information
  - pg_ctl -D /usr/local/var/postgres status

### 4.5 Ruby<a name='ruby'></a>

Ruby version is read from the Gemfile and during the push to DOKKU.  
Heroku, which Dokku was based, has a page on [specifying a Ruby Version](https://devcenter.heroku.com/articles/ruby-versions)

### 4.6 scp<a name='scp'></a>

- for copying files between servers

scp -r user@your.server.example.com:/path/to/file /home/user/Desktop/file

#### 4.7 SSH<a name='ssh'></a>

1. brew install ssh-copy-id
2. ssh-copy-id deployer@example.com
3. ssh deployer@example.com (verify)

## 5 Trouble Shooting<a name='troubleshooting'></a>

### 5.1 Net::SSH::HostKeyMismatch<a name='net-ssh-hostkeymismatch'></a>

Error seen as something like:

fingerprint d2:82:b0:34:3c:df etc does not match for "193.183.99.251" Copy the workstation public key to the server.

Problem:
Computers keep a unique identifier of servers they have connected with so that they can prevent a bad actor pretending they are that server. However, sometimes the ID of the server changes in which case you need to reset the server.

Solution

`ssh-keygen -R <ip address> | <name>`

### 5.2 How to fix duplicate source.list entry<a name='how-to-fix-duplicate-source-list-entry'></a>

Format of Repository Source List found in `/etc/apt/sources.list` and `/etc/apt/sources.list.d/`
`<type of repository> <location> <dist-name> <components>`

Example
`deb http://archive.ubuntu.com/ubuntu bionic main`

Example of a duplicate

- In the example 'universe' has been duplicated

```
deb http://archive.ubuntu.com/ubuntu bionic universe
deb http://archive.ubuntu.com/ubuntu bionic main universe
```

- Fix - this is equivalent

```
deb http://archive.ubuntu.com/ubuntu bionic main universe
```

Further Reading
http://askubuntu.com/questions/120621/how-to-fix-duplicate-sources-list-entry

### 5.5 Cron<a name='cron'></a>

1. Is Cron running? `ps uww -C cron`
2. Has Cron run? check syslog: `tail -200 /var/log/syslog`

### 5.6 Elasticsearch Faraday::ConnectionFailed<a name='elasticsearch-connection-failed'></a>

```
   Failure/Error: Client.import force: true, refresh: true
       Faraday::ConnectionFailed:
         Connection refused - connect(2) for "localhost" port 9200
```

Reset Elasticsearch

```
sudo service elasticsearch restart
```

Somtimes it won't delete the Elasticsearch pid file.

```
    Stopping elasticsearch...PID file found, but no matching process running?
    Removing PID file...
    rm: cannot remove ‘/usr/local/var/run/10_0_0_101.pid’: Permission denied

    To Remove
    sudo rm /usr/local/var/run/10_0_0_101.pid

    Repeat Restart

```

### 5.7 Truncating a file without changing ownership<a name='truncating-a-file-without-changing-ownership'></a>

```
cat /dev/null > /file/you/want/to/wipe-out
```

### 5.8 Recursive diff of two directories<a name='recursive-diff-of-two-directories'></a>

```
diff -r letting/ letting_diffable/ | sed '/Binary\ files\ /d' >outputfile
```

===

## 6 Production Client

On release of the version go through the [production checklist](https://github.com/BCS-io/letting/blob/master/docs/production_checklist.md)

===

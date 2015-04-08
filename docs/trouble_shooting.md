[Read Me](https://github.com/BCS-io/letting/blob/master/README.md)

##5. TROUBLESHOOTING

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

[Read Me](https://github.com/BCS-io/letting/blob/master/README.md)
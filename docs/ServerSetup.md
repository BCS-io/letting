# Server Setup

1) Create a server on web
  - cloud server uses terraform and updates /etc/hosts
    sudo bin/run -a -d
      - create cloud server
       -a - apply without destroying
       -d - development server
  - local server requires install with checklist
    - See "Server Setup below" - the cannonical version is
      kept in Evernote Adams Letting Checklist / Server Setup

2) - playbooks installed
     bin/ansible-galaxy-requirements

3) - playbook executed
     bin/ansible-playbook -d

4) - clean fingerprint for server from local machine
     bin/clean -d

4) - push repo to server
     bin/gp -d

5) - playbook executed - now with repo push
     bin/ansible-playbook -d
     




## Server


* Root account
* Cloud servers have a root account.
* Installing server from a download does not have a root account.
* Deployer
* Cloud servers does not have a deployer account
* Installing server from a download means you can add a deployer account
* the deployer account does not have passwordless sudo

1. Ubuntu 18.04 [x]
2. /11 - Keyboard UK [x]
3. /11 - Install Ubuntu [x]
4. /11 - Network address [x]
1. Manual
1. Subnet 10.0.0.0/24
2. Address: 10.0.0.X (40 for jura)
3. Gateway: 10.0.0.1
4. Nameserver: 8.8.8.8, 8.8.4.4
5. Searchdomain:
* /11 - Proxy:  [x]
* /11 - default ubuntu address
* /11 - Use entire disk [x]
* /11 - choose a disk [x]
1. take all the defaults
* /11 - Profile setup
1. Name: deployer
2. Server Name: (jura)
3. Username: deployer
4. Password / confirm: std
5. Import ssh from github
1. Github username: notapatch
* /11 - Popular server: [x]
* Message [x]
* User must have password less sudo
1. sudo visudo
2. on last line:
1. %deployer ALL=(ALL) NOPASSWD: ALL
* service sudo restart  (didn’t work and rebooted - doh! maybe the network is the problem?)

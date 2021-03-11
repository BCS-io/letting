![Bcs.io](docs/images/application.svg)

# Letting Website

Monorepo for a lettings website. Installation is to an Ubuntu server instance configured by Terraform with [Dokku](2) providing a PaaS instance which the Rails instance is run on. The actual website, fl-adams.uk, is behind a firewall.

## Project Structure

### Ansible

Ansible script provisions the server with systems required to run Rails 5.2 app on Dokku. While final deployment is to Dokku it would work by deploying to Heroku.

### Bin

Bash scripts used to wrap common complicated commands.


### Design

Artwork masters for the website. Designs are in Affinity Designer format.

### Rails

Rails monolith for the lettings website.


### Terraform

Terraform configuration is specific for a single cloud provider. If you required the automation of server creation then this would need to be changed. Otherwise it can be ignored.

---
## Getting Started

### Create a server
1. Clean up ssh keys
2. Create new server by environment
   - Update DNS to the ip address
3. Install playbooks
4. Provision with Ansible playbook
5. Deploy code
6. Provision with Ansible playbook (Required for SSL)

Which gives:
```
bin/clean -p
bin/run -p -a 
# Update DNS if ip addresses have changed
bin/ansible-galaxy-requirements
bin/ansible-playbook -p
bin/deploy -p
bin/ansible-playbook -p -t ssl
```

### Removing a server
  1. Destroy server by environment (development/staging/production)
  2. Clean fingerprint of server from local machine by removing ssh keys associated with the server name or ip address
  3. Clear DNS cache (Mac OS code)


Which gives:
```
bin/terraform -d production
bin/clean -p
sudo killall -HUP mDNSResponder
```

[1]: https://bcs.io
[2]: https://github.com/dokku/dokku


### Update database
1. Log into AWS S3 and download latest backup
2. Unzip the file leaving a file called "export"
3. Copy "export" to the postgres_backup_file location
   1. currently : roles/dokku/files/export
4. bin/ansible-playbook -s -t import

[Read Me](https://github.com/BCS-io/letting/blob/master/README.md)

###4 Cheatsheet

#####4.1 QEMU

Source files on host: `/var/lib/libvirt/images/`

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
<br>

[Read Me](https://github.com/BCS-io/letting/blob/master/README.md)
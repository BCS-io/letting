# Logstash

## Table of Contents
1. [Introduction](#introduction)
1. [Logstash Architecture](#logstash-architecture)
1. [Shipper](#shipper)
1. [Logstash Forwarder](#logstash-forwarder)

===

## Introduction

* Logstash is a way of gathering system messages on any number of computers and storing them on a server(s) where you can then search through them.
<br><br>

## Logstash Architecture

````
                                                                             -------
    Shipper ---->   -----------      -----------      ------------------     |     |
                    | Broker  | ---> | Indexer | ---> | Search & Store | --> | Web |
    Shipper ---->   -----------      -----------      ------------------     | Gui |
                                                                             -------
````

| Name           | Description                                                            |
|:---------------|:---------------------------------------------------------------------- |
| Shipper        | runs software which gathers and sends messages to the Logstash broker. |
| Broker         | receives the incoming messages and queues them if necessary.           |
| Indexer        | intercepts and processes the log messages as defined by the admin.     |
| Search & Store | Elasticsearch database performs storage and full text search duties.   |
| Web Gui        | Kibana a configurable web-gui provided by the company Elasticsearch.   |


####How do we implement the architecture?

* Shipper - is installed on all machines that need to share their log files.
* Broker/Indexer/Search & Store / WebGui - is installed on one or more additional machines
<br><br>

## Shipper

* Installed on all machines that need their log files collated
* A number of shipper options are available.

### Shipper Options

| Name               | Description                 | Java  | Encrypt |
|:------------------ |:--------------------------- |:----- |:--------|
| Logstash Agent     | Standard Shipper            | Yes   | None    |
| Syslog             | Ubiquitous messager         | No    | None    |
| Logstash Forwarder | Standard Low Memory Shipper | No    | SSL     |

[If you need to encrypt Logstash Agent or Syslog you should look at Stunnel or VPN.](http://serverfault.com/questions/20840/how-would-you-send-syslog-securely-over-the-public-internet)[2]
* For my requirements I am using Logstash Forwarder.
<br>
<br>

## Logstash Forwarder

[Logstash Forwarder is an opensource application.](https://github.com/elastic/logstash-forwarder)[3]
  * formally known as lumberjack

### Chef Logstash forwarder configuration

Add the forwarder recipe to the cookbook

  `include_recipe 'bcs_logstash_forwarder::default'`
* I have included the recipe in a base cookbook, website-cookbook - which means it gets installed by default.


#### Installs

| Name               | Description                                  |
|:------------------ |:-------------------------------------------- |
| certificate        | Installs private certificate for SSL to work |
| logstash-forwarder | Message Shipper                              |


#### Configuration

| Attribute                                                  | Description                       |
|:---------------------------------------------------------- |:--------------------------------- |
| `default['logstash-forwarder']['hosts']  = %w{ 8.8.8.8 }`  | ip address of the Logstash server |



### TODO
#### Logstash-forwarder certificate ....
#### Chef Logstash Server Configuration





### Further Reading

[1]: [Logstashbook - payment required.](http://www.logstashbook.com/)

[2]: [How would you send syslog securely over the public Internet.](http://serverfault.com/questions/20840/how-would-you-send-syslog-securely-over-the-public-internet)

[3]: [Logstash forwarder](https://github.com/elastic/logstash-forwarder)
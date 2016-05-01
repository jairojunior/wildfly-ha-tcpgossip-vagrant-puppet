## Wildfly Standalone HA + Gossip Router Vagrant Puppet

## Requirements

Working vagrant and Virtualbox.

Ruby (checkout RVM: https://rvm.io/)

Docker (for Gossip Router)

Then:

`./setup.sh`

OR

`wget http://central.maven.org/maven2/org/jgroups/jgroups/3.2.13.Final/jgroups-3.2.13.Final.jar`

`vagrant up gossiprouter --provider=docker`

`gem install r10k --no-ri --no-rdock`

`r10k puppetfile install`

`vagrant up`

## Environment

Multi-machine environment with:

* gossiprouter (Very simple docker container running a Gossip Router, useful where multicast is not an option, like AWS and other cloud providers)
* load-balancer (centos-7-httpd-modcluster) (Apache + mod_cluster)
* instance1 (centos-7-instance1) (Wildfly 9.0.2 Standalone Full HA)
* instance2 (centos-7-instance2)(Wildfly 9.0.2 Standalone Full HA)

New instances can be provisioned with the following convention: **instanceN (centos-7-instanceN)**

Check: `environments/production/manifests/site.pp`

Using:

* biemond-wildfly
* puppetlabs-apache
* puppetlabs-stdlib
* puppetlabs-concat
* puppetlabs-java
* crayfishx/firewalld

## Console

http://172.28.128.20:9990

http://172.28.128.30:9990

user: wildfly

password: wildfly

## mod_cluster_manager

http://172.28.128.10:6666/mod_cluster_manager

## cluster-demo

cluster-demo is a sample application to test cluster behavior: https://github.com/liweinan/cluster-demo

http://172.28.128.10/cluster-demo

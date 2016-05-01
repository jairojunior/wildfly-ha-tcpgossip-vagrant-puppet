#!/bin/bash

wget http://central.maven.org/maven2/org/jgroups/jgroups/3.2.13.Final/jgroups-3.2.13.Final.jar
vagrant up gossiprouter --provider=docker
gem install r10k --no-ri --no-rdock
r10k puppetfile install
vagrant up

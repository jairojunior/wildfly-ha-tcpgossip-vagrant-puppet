#!/bin/bash

wget http://central.maven.org/maven2/org/jgroups/jgroups/3.2.13.Final/jgroups-3.2.13.Final.jar
gem install r10k --no-ri --no-rdoc
r10k puppetfile install
vagrant up

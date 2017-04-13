#!/bin/bash

gem install r10k --no-ri --no-rdoc
r10k puppetfile install
vagrant up load-balancer instance1 instance2
vagrant up gossiprouter --provider docker

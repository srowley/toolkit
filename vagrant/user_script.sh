#!/usr/bin/env bash

curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm use --install 2.1.1
ruby -v
gem install rails --no-ri --no-rdoc

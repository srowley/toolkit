#!/usr/bin/env bash

curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm use --install 2.1.1
rvm use --default 2.1.1
gem install rails --no-ri --no-rdoc

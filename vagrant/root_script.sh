#!/usr/bin/env bash

echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main"| sudo tee -a /etc/apt/sources.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install curl git tmux vim postgresql-9.3 libpq-dev -y
cd /vagrant
git clone https://github.com/srowley/toolkit.git
cp /vagrant/toolkit/dotfiles/.bashrc /home/vagrant/.bashrc
cp /vagrant/toolkit/dotfiles/.vimrc /home/vagrant/.vimrc
cp /vagrant/toolkit/dotfiles/.railsrc /home/vagrant/.railsrc
source /home/vagrant/.bashrc
sudo -u postgres createuser -a vagrant
mkdir -p /home/vagrant/.vim/autoload /home/vagrant/.vim/bundle
curl -LSso /home/vagrant/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

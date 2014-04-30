echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main"| sudo tee -a /etc/apt/sources.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install curl git tmux vim postgresql-9.3 libpq-dev -y
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
rvm use --install 2.1.1
gem install rails --no-ri --no-rdoc
cd /vagrant
git clone https://github.com/srowley/toolkit.git
cp /vagrant/toolkit/dotfiles/.bashrc ~/.bashrc
cp /vagrant/toolkit/dotfiles/.tmux.conf ~/.tmux.conf
cp /vagrant/toolkit/dotfiles/.vimrc ~/.vimrc
source ~/.bashrc

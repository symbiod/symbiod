# !/usr/bin/env bash

echo "set timezone"
sudo timedatectl set-timezone Asia/Tokyo

sudo apt-get update

if [[ ! -e $HOME/.rbenv ]]; then
  echo "Install packages"
  sudo apt-get install -y git build-essential libssl-dev libcurl4-openssl-dev libreadline-dev libsqlite3-dev

  echo "Install rbenv"
  git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.profile
  echo 'eval "$(rbenv init -)"' >> $HOME/.profile

  echo "Install ruby-build"
  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build

  echo "Install rbenv-gem-rehash"
  git clone https://github.com/sstephenson/rbenv-gem-rehash.git $HOME/.rbenv/plugins/rbenv-gem-rehash

  echo "Setup gemrc"
  echo 'install: --no-document' >> $HOME/.gemrc
  echo 'update: --no-document' >> $HOME/.gemrc

  source $HOME/.profile

  echo "Install ruby"
  rbenv install 2.5.1
  rbenv global 2.5.1

  ruby -v

  echo "Install bundler"
  gem install bundler
fi

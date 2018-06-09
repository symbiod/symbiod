# !/usr/bin/env bash

if ! which nodejs; then
  echo "Installing NodeJS"
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  sudo apt-get install -qy nodejs
else
  echo "NodeJS is installed"
fi

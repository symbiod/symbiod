# !/usr/bin/env bash

set -e

if [ -e /.chromedriver ]; then
  echo 'Chromedriver is already installed.'
else
  sudo apt-get -qy install chromium-chromedriver
  sudo ln -s /usr/lib/chromium-browser/chromedriver /usr/bin/chromedriver
  touch /.chromedriver
fi

# Start Xvfb, Chrome, and Selenium in the background
export DISPLAY=:10
cd /vagrant

echo "Starting Xvfb ..."
Xvfb :10 -screen 0 1366x768x24 -ac &

echo "Starting Google Chrome ..."
google-chrome --remote-debugging-port=9222 &

echo "Starting Selenium ..."
cd /usr/local/bin
nohup java -jar ./selenium-server-standalone-2.35.0.jar &

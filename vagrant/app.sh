# !/usr/bin/env bash
cd /app
bundle install
cp config/database.yml{.vagrant,}
rake db:create && rake db:schema:load
RAILS_ENV=features rake db:create && RAILS_ENV=features rake db:schema:load

cd /features
bundle install

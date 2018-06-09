# !/usr/bin/env bash

PG_PKG=postgresql
PG_INSTALLED=$(dpkg -l | grep -q ${PG_PKG} || echo "NOT")
if [ "x${PG_INSTALLED}" = "xNOT" ] ; then

  echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' > /etc/apt/sources.list.d/pgdg.list
  wget https://www.postgresql.org/media/keys/ACCC4CF8.asc --no-check-certificate
  apt-key add ACCC4CF8.asc
  apt-get update

    echo 'Name: libraries/restart-without-asking
Template: libraries/restart-without-asking
Value: true
Owners: libssl1.0.0
Flags: seen' >> /var/cache/debconf/config.dat

  apt-get -qy install postgresql-9.6 postgresql-contrib-9.6 postgresql-server-dev-9.6 libpq-dev

  sed -i "s|#listen_addresses.*$|listen_addresses = '*' |g" /etc/postgresql/9.6/main/postgresql.conf
  echo "host    all             all             all               trust" > /etc/postgresql/9.6/main/pg_hba.conf
  /etc/init.d/postgresql restart
fi

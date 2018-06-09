# !/usr/bin/env bash

REDIS_PKG=redis-server
REDIS_INSTALLED=$(dpkg -l | grep -q ${REDIS_PKG} || echo "NOT")
if [ "x${REDIS_INSTALLED}" = "xNOT" ] ; then
  apt-get -qy install $REDIS_PKG
  sed -i "s|bind 127.0.0.1|#bind = 127.0.0.1|g" /etc/redis/redis.conf
  /etc/init.d/redis-server restart
fi

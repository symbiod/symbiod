# !/usr/bin/env bash

sed -i '/AcceptEnv LANG LC_*/c\AcceptEnv *' /etc/ssh/sshd_config
service ssh restart

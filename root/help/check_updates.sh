#!/bin/bash
set -e
apt-get update -qq &>/dev/null
apt-get upgrade -y -qq &>/dev/null 
apt-get clean autoclean -qq &>/dev/null
apt-get autoremove -y -qq &>/dev/null
/usr/local/bin/python3 -m pip -q install -r <(pip freeze) --upgrade &>/dev/null
rm -rf /var/lib/apt/* 
rm -rf /var/lib/cache/* 
rm -rf /var/lib/log/* 
rm -rf /tmp/* 
rm -rf /var/tmp/*
rm -rf /usr/share/doc/
rm -rf /usr/share/man/
rm -rf /usr/share/locale/
rm -rf /root/.cache
rm -rf /var/log/*
mkdir -p /var/log/nginx
mkdir -p /var/log/mysql
chown mysql:root /var/log/mysql
touch /help/first_run_done
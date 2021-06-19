#!/bin/bash
set -e
secretuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c32; echo)
secretpass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c32; echo)
mkdir -p /etc/supervisor
cp /help/supervisord.conf /etc/supervisor/supervisord.conf
sed -i "s/secretuser/$secretuser/g" /etc/supervisor/supervisord.conf
sed -i "s/secretpass/$secretpass/g" /etc/supervisor/supervisord.conf
touch /help/supervisor_secure
chmod 400 /help/supervisor_secure
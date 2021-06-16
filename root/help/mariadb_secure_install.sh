#!/bin/bash
set -e
sleep 20
MARIADB_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%+~*.:,;=?<>()[]{}' | head -c32; echo)
expect /help/mariadb_secure_install.expect $MARIADB_ROOT_PASSWORD
echo $MARIADB_ROOT_PASSWORD > /home/tor/mariadb/mariadb_root_password.txt
chmod 600 /home/tor/mariadb/mariadb_root_password.txt
touch /help/mariadb_secure_install_done
exit 0
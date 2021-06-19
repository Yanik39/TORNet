#!/bin/bash

set -e

sleep 20

root_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%+~*.:,;=?<>()[]{}' | head -c32; echo)
echo $root_pass > /root/mariadb_root_password.txt
chmod 400 /root/mariadb_root_password.txt
expect /help/mariadb_secure_install.expect $root_pass

cp /help/my.cnf /root/.my.cnf
sed -i "s/^user=.*/user=root/g" /root/.my.cnf
sed -i "s/^password=.*/password=\"${root_pass}\"/g" /root/.my.cnf

touch /help/mariadb_secure_install_done
chmod 400 /help/mariadb_secure_install_done
exit 0
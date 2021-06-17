### TorNet: All in One Container for Hidden Services

TorNet is all in one system to work as hidden-service. TorNet has all necessary applications such as NGINX, PHP-FPM, MariaDB to host your hidden service. 
And also to secure and optimize Tor connection, latest version of Vanguards is also installed along side with Tor monitoring software NYX. Also dnsmasq is handling all DNS queries over Tor connection.

#### Notes
  * It's wise to use seperate Docker Network for TorNet.
 
      * `docker network create PrivateNet`

  * To avoid permission issues pass your UID and GID as ENV variable. Please run following commands at your terminal to get your UID and GID, if you dont know them already.
 
      * UID: `id -u`
      * GID: `id -g`

  * It's better not to pass your Timezone to Container, default is UTC.
  * You will get your random MariaDB/MySQL password at your `/home/tor/mariadb` folder.
  * Please delete or rename the `phpinfo.php` file at `/home/tor/www/host_1/public_html` Which is there to check everything is working.

#### Deploy

  ```bash
  docker network create PrivateNet
  
  docker run -d 
    --name TorNet \
    -e UID=$(id -u) \
    -e GID=$(id -g) \
    -v ~/docker/TorNet:/home/tor \
    --hostname TorNet \
    --network PrivateNet \
    --restart unless-stopped \  
    yanik39/tornet:latest
  ```

#### Bash Terminal Aliases
  * `hs` to get domain names hosted at your TorNet.
  * `ns` to see listening sockets and ports.
  * `hc` to manualy trigger HealthCheck.


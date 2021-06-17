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
  * Its better to use Nyx as tor user (`su tor`). To avoid warnings about being root and to use config file which is located at home folder.

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

### Some Features
 * `tor <-> nginx` connection is established with socket. Nginx is not listening any ip or port.
 * `nginx <-> php8.0-fpm` connection is established with socket.
 * `nginx` is hardened, so exposing nothing.
 * `php` is hardened by disabling any settings exposes any info.
 * `php-fpm` clears all env variables.
 * `supervisor <-> supervisorctl` connection is secured with auto created random password.
 * `MariaDB/MySQL` secure_install is done after first install. Any you get the auto generated random password at home folder.
 * If you messed with configs/files etc. just delete file/folder to get default ones after restart of the container.
 * Vanguards is hardening tor connections. I suggest to check it out.
 * 5-Eye countries are blocked as any kind of nodes (Exit or middle). There is some warnings about this at tor logs, but safe to ignore.
 * Nyx is ready to run to check tor connection with nice GUI. With proper settings at home folder.

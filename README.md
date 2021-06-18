## All in One Container for Hidden Services

[TORNet](https://github.com/Yanik39/TORNet) is all in one system to work as [hidden-service](https://www.linuxjournal.com/content/tor-hidden-services). TORNet has all necessary applications such as NGINX, PHP-FPM, MariaDB to host your hidden service. 
And also to secure and optimize [Tor](https://2019.www.torproject.org/about/overview.html.en) connection, latest version of Vanguards is also installed along side with Tor monitoring software NYX. Also dnsmasq is handling all DNS queries over Tor connection. You may get the images from [Docker Hub](https://hub.docker.com/r/yanik39/tornet) or [GitHub](https://github.com/Yanik39/TORNet) / [GitHub Packages](https://github.com/Yanik39?tab=packages&repo_name=TORNet).


### Notes
  * It's wise to use separate Docker Network for TORNet.
    * `docker network create PrivateNet`
  
  * To avoid permission issues pass your UID and GID as ENV variable. Please run following commands at your terminal to get your UID and GID, if you don't know them already.
    * UID: `id -u`
    * GID: `id -g`
  
  * It's better not to pass your Timezone to Container, default is UTC.
  * You will get your random MariaDB/MySQL password at your `/home/tor/mariadb` folder.
  * Please delete or rename the `phpinfo.php` file at `/home/tor/www/host_1/public_html` Which is there to check everything is working.
  * It's better to use Nyx as tor user (`su tor`). To avoid warnings about being root and to use configuration file which is located at tor home folder.

### Deploy

  ```bash
  docker network create PrivateNet
  
  docker run -d 
    --name TORNet \
    -e UID=$(id -u) \
    -e GID=$(id -g) \
    -v ~/docker/TORNet:/home/tor \
    --hostname TORNet \
    --network PrivateNet \
    --restart unless-stopped \  
    yanik39/tornet:latest
  ```
  
### Supervisor
  * Supervisor is controlling all services.
  * You may control Supervisor with SupervisorCTL
    * **Usage is possible only with root user.**
    * From the container;
      * `supervisorctl status`
      * `supervisorctl reload`
      * `supervisorctl help`
      * `supervisorctl restart TOR` ..etc
    
    * From the host system
      * `docker exec -it TORNet supervisorctl status`
      * `docker exec -it TORNet supervisorctl reload`
      * `docker exec -it TORNet supervisorctl restart TOR` ..etc

### Logging
  * Logging is disabled by default except Tor itself while Tor and Vanguards already hides/scrambles sensitive data from Tor logs. So its safe to remain on. If you may want also turn it off, edit `torrc` config file at the Tor home folder.
  * There is a useful script to manage logging for all managed services (`nginx`, `php-fpm`, `mysql/mariadb` etc.). 
    * **Usage is possible only with root user.**
    * From the container;    
      * `torlog status`
      * `torlog disable`
      * `torlog enable`
     
     * From the host system;
       * `docker exec -it TORNet torlog status`
       * `docker exec -it TORNet torlog enable`
       * `docker exec -it TORNet torlog disable`
  
  * System starts with NoLog policy, if you like to debug the system just enable logging by running one of the following commands; 
    * `torlog enable`
    * `docker exec -it TORNet torlog enable`

### Bash Terminal Aliases
  * `hs` to get domain names hosted at your TORNet.
  * `ns` to see listening sockets and ports.
  * `hc` to manually trigger HealthCheck.

### Some Features
  * `tor <-> nginx` connection is established with socket. Nginx is not listening any IP or port.
  * `nginx <-> php8.0-fpm` connection is established with socket.
  * `nginx` is hardened, so exposing nothing.
  * `php` is hardened by disabling any settings exposes any info.
  * `php-fpm` clears all ENV variables.
  * `supervisor <-> supervisorctl` connection is secured with auto generated random password.
  * `MariaDB/MySQL` mysql_secure_install is done after first install. Any you get the auto generated random password at tor home folder.
  * If you messed with configurations/files/folders etc. just delete file/folder to get default ones after restart of the container.
  * [Vanguards](https://github.com/mikeperry-tor/vanguards) is hardening tor connections. I suggest also checking related [Tor Blog](https://blog.torproject.org/announcing-vanguards-add-onion-services) post.
  * 5-Eye countries are blocked as any kind of nodes (exit or middle). There is some warnings about this at tor logs, but safe to ignore.
  * Nyx is ready to run to check tor connection with nice GUI. With proper settings at tor home folder.

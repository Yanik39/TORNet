FROM python:slim

ENV	DEBIAN_FRONTEND="noninteractive" \
	TERM="xterm-256color" \
	LC_ALL=C.UTF-8
	
RUN apt-get update -qq && apt-get upgrade -y --with-new-pkgs -qq \
	&& apt-get install -y --no-install-recommends -qq apt-utils \
		apt-transport-https ca-certificates gnupg curl wget bash		 

COPY root/ /

RUN cd /tmp \
	&& curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import \
	&& gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
	&& wget -qO - https://nginx.org/keys/nginx_signing.key | apt-key add - \
	&& wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - \
	&& apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
	&& apt-get update -qq && apt-get upgrade -y --with-new-pkgs -qq \
	&& apt-get install -y --no-install-recommends --no-install-suggests -qq \
		deb.torproject.org-keyring tor obfs4proxy torsocks tor-geoipdb \
		nginx dnsmasq mariadb-server mariadb-client php8.0-mysql php8.0-xml \
		php8.0-fpm php8.0-bcmath php8.0-bz2 php8.0-curl php8.0-dom php8.0-zip \
		php8.0-gd php8.0-gmp php8.0-imap php8.0-intl php8.0-mbstring \
		nano net-tools dnsutils zip unzip expect \
	&& apt-get update -qq && apt-get upgrade -y --with-new-pkgs -qq \
	&& apt-get clean autoclean -qq && apt-get autoremove -y -qq \
	&& /usr/local/bin/python3 -m pip install --upgrade pip \
	&& /usr/local/bin/python3 -m pip install stem ipaddr nyx supervisor \
	&& rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/* \
		/usr/share/doc/ /usr/share/man/ /usr/share/locale/ /root/.cache /root/.gnupg \
	&& chmod +x /TORNet /help/HealthCheck /help/*.sh /help/*.expect \
	&& groupadd tor && useradd -ms /bin/bash -g tor tor \
	&& chown -R tor:tor /home/tor /usr/local/tor

HEALTHCHECK --interval=3m --timeout=30s --start-period=5m --retries=10 \
	CMD ["/bin/bash","-c","/help/HealthCheck"]
	
ENTRYPOINT ["/TORNet"]
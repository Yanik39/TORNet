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
		nginx dnsmasq mariadb-server mariadb-client php8.1-mysql php8.1-xml \
		php8.1-fpm php8.1-bcmath php8.1-bz2 php8.1-curl php8.1-dom php8.1-zip \
		php8.1-gd php8.1-gmp php8.1-imap php8.1-intl php8.1-mbstring \
		nano net-tools dnsutils zip unzip expect \
	&& apt-get update -qq && apt-get upgrade -y --with-new-pkgs -qq \
	&& apt-get clean autoclean -qq && apt-get autoremove -y -qq \
	&& /usr/local/bin/python3 -m pip install --upgrade pip \
	&& /usr/local/bin/python3 -m pip install stem ipaddr nyx supervisor \
	&& rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* /tmp/* /var/tmp/* \
		/usr/share/doc/ /usr/share/man/ /usr/share/locale/ /root/.cache /root/.gnupg \
	&& groupadd tor && useradd -ms /bin/bash -g tor tor \
	&& chown -R tor:tor /home/tor /usr/local/tor \
	&& chmod 600 /help/supervisord.conf /help/my.cnf \
	&& chmod 644 /help/bashrc /help/resolv.conf /help/dnsmasq.conf \
	&& chmod 700 /TORNet /help/mariadb* /help/check_updates.sh \
		/help/fix_permissions.sh /help/supervisor_secrets.sh \
		/usr/local/bin/torlog /usr/local/bin/tordb \
	&& chmod 777 /help/Health*
	

HEALTHCHECK --interval=2m --timeout=39s --start-period=3m --retries=10 \
	CMD ["/bin/bash","-c","/help/HealthCheck"]
	
ENTRYPOINT ["/TORNet"]

FROM ubuntu:16.04
MAINTAINER SFoxDev <admin@sfoxdev.com>

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    INSTALL_PKG="php-xdebug"

RUN set -ex ; \
    apt-get -y update && apt-get -y upgrade ; \
    apt-get -y install \
      apache2 libapache2-mod-php7.0 composer cron curl mc mysql-client inetutils-ping \
      php7.0 php7.0-mysql php7.0-dom php7.0-simplexml php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-xml \
      php7.0-bcmath php7.0-gd php7.0-mcrypt php7.0-soap php7.0-json php7.0-iconv php-imagick \
      ${INSTALL_PKG} ; \
    a2enmod rewrite ; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer ; \

    apt-get clean autoclean ; \
    apt-get autoremove --yes ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;

ADD conf/ /

RUN chmod +x /setup.sh

EXPOSE 80 443

VOLUME ["/var/www/html"]

ENTRYPOINT ["/setup.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]

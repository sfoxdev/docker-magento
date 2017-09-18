#!/bin/bash

if [ ! -f /root/configured ]
then
  cd /var/www/html
  echo "===== Drop database if exist ====="
  mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -e "DROP DATABASE IF EXISTS ${MYSQL_DATABASE}"
  echo "===== Create database ====="
  mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -e "CREATE DATABASE ${MYSQL_DATABASE}"
  echo "=============================== MySQL Import Magento 2.1.8 data into database ==============================="
  mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -D ${MYSQL_DATABASE} < /root/magento-2.1.8_default.sql
  echo "=============================== MySQL Import project data into database ==============================="
  mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -D ${MYSQL_DATABASE} < /root/magento2_dev.sql

  rm /var/www/html/index.html

  tar --strip-components=3 -xzf /root/magento-2.1.8.tar.gz
  echo "=============================== Chmod files ==============================="
  chmod -R 755 /var/www/html/
  chmod -R 777 /var/www/html/app/etc
  chmod -R 777 /var/www/html/var/
  chmod -R 777 /var/www/html/pub/
  chmod 755 /var/www/html/bin/magento
  chown -R www-data:www-data /var/www/html/

  echo "=============================== Copy files ==============================="

  cp /var/www/html/bin/magento /root/magento
  cp -r /var/www/html-tmp/* /var/www/html
  cp /root/config.php /var/www/html/app/etc/config.php
  cp /root/magento /var/www/html/bin/magento2

  echo "=============================== Chmod files ==============================="

  chmod -R 755 /var/www/html/
  chmod -R 777 /var/www/html/app/etc
  chmod -R 777 /var/www/html/var/
  chmod -R 777 /var/www/html/pub/
  chmod 755 /var/www/html/bin/magento
  chown -R www-data:www-data /var/www/html/

  echo "=============================== Configuring Magento ==============================="
  mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -v -e "USE ${MYSQL_DATABASE}; UPDATE admin_user SET email='${MAGENTO_ADMIN_EMAIL}' WHERE username='${MAGENTO_ADMIN_USERNAME}';"
  php bin/magento2 setup:config:set -n --db-host=${MYSQL_HOST} --db-name=${MYSQL_DATABASE} --db-user=${MYSQL_USER} --db-password=${MYSQL_PASSWORD} --backend-frontname=${MAGENTO_ADMINURL}
  php bin/magento2 setup:store-config:set -n --base-url=${MAGENTO_URL} --base-url-secure=${MAGENTO_SECUREURL} --language=${MAGENTO_LOCALE} --currency=${MAGENTO_DEFAULT_CURRENCY} --timezone=${MAGENTO_TIMEZONE} --use-rewrites=${MAGENTO_USE_REWRITES} --use-secure=${MAGENTO_SECURE} --use-secure-admin=${MAGENTO_SECUREADMIN}
  php bin/magento2 admin:user:create -n --admin-firstname=${MAGENTO_ADMIN_FIRSTNAME} --admin-lastname=${MAGENTO_ADMIN_LASTNAME} --admin-email=${MAGENTO_ADMIN_EMAIL} --admin-user=${MAGENTO_ADMIN_USERNAME} --admin-password=${MAGENTO_ADMIN_PASSWORD}
  mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -v -e "USE ${MYSQL_DATABASE}; INSERT INTO core_config_data SET path='system/smtp/disable', value='${SMTP_DISABLE}'; INSERT INTO core_config_data SET path='system/smtp/host', value='${SMTP_HOST}'; INSERT INTO core_config_data SET path='system/smtp/port', value='${SMTP_PORT}'; INSERT INTO core_config_data SET path='system/smtp/set_return_path', value='${SMTP_SET_RETURN_PATH}'; INSERT INTO core_config_data SET path='system/smtp/return_path_email', value='${SMTP_RETURN_PATH_EMAIL}'; "

  #php bin/magento2 deploy:mode:set developer
  echo "=============================== Clear cache ==============================="
  rm -rf /var/www/html/var/cache /var/www/html/var/generation /var/www/html/var/page_cache
  echo "=============================== List environments ==============================="
  export

  touch /root/configured
  echo "0" > /root/configured
  echo "-= Starting Apache =-"
  exec "$@"

else
  rm -f /var/run/apache2/apache2.pid
  echo "1" > /root/configured
  echo "-= Magento is configured. Starting Apache =-"
  exec "$@"
fi

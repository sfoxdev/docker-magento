#!/bin/bash

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

echo "=============================== Configuring Magento ==============================="
cp /root/env.php /var/www/html-tmp/app/etc/env.php

sed -i "s/MAGENTO_ADMINURL/${MAGENTO_ADMINURL}/g" /var/www/html-tmp/app/etc/env.php
sed -i "s/MYSQL_HOST/${MYSQL_HOST}/g" /var/www/html-tmp/app/etc/env.php
sed -i "s/MYSQL_DATABASE/${MYSQL_DATABASE}/g" /var/www/html-tmp/app/etc/env.php
sed -i "s/MYSQL_USER/${MYSQL_USER}/g" /var/www/html-tmp/app/etc/env.php
sed -i "s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g" /var/www/html-tmp/app/etc/env.php
sed -i "s/SERVER_NAME/${SERVER_NAME}/g" /etc/apache2/apache2.conf

echo "=============================== Copy files ==============================="

cp /var/www/html/bin/magento /root/magento
cp -r /var/www/html-tmp/* /var/www/html
cp /root/config.php /var/www/html/app/etc/config.php

#echo "=============================== php bin/magento cache:flush ==============================="
#php bin/magento cache:flush
#echo "=============================== php bin/magento cache:clean ==============================="
#php bin/magento cache:clean
#echo "=============================== php bin/magento indexer:reindex ==============================="
#php bin/magento indexer:reindex
#echo "=============================== php bin/magento cache:enable ==============================="
#php bin/magento cache:enable

#echo "=============================== setup upgrade ==============================="
#php bin/magento setup:upgrade
#echo "=============================== setup di compile ==============================="
#php -d set_time_limit=3600 -d memory_limit=1024M bin/magento setup:di:compile

echo "=============================== Chmod files ==============================="

chmod -R 755 /var/www/html/
chmod -R 777 /var/www/html/app/etc
chmod -R 777 /var/www/html/var/
chmod -R 777 /var/www/html/pub/
chmod 755 /var/www/html/bin/magento
chown -R www-data:www-data /var/www/html/

cp /root/magento /var/www/html/bin/magento2
#php bin/magento2 deploy:mode:set developer

echo "-= Starting Apache =-"

exec "$@"

# Magento

Magento 2.1.8 container based on Ubuntu 16.04 + Apache 2.4 + PHP 7.0.22

[![Docker Build Status](https://img.shields.io/docker/build/sfoxdev/magento.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/automated/sfoxdev/magento.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/pulls/sfoxdev/magento.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/stars/sfoxdev/magento.svg?style=flat-square)]()


## Usage

### Prepare needed files and build container

1. Put your webstore files into /srv/magento folder

2. Using CLI mysql-client make dump of database and put it in /root folder with name magento2_dev.sql (use only cli command !!!)
```
mysqldump -uMYSQL_USER -pMYSQL_PASSWORD -hMYSQL_HOST MYSQL_DATABASE > /root/magento2_dev.sql
```

3. Change setting in docker-compose.yml file


4. Build and run container

```
docker-compose -d --build up
```

5. After container starts check configuration process until you see message: "-= Starting Apache =-"

```
docker logs magento
```

6. Visit website

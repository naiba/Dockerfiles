# Dockerfiles ![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fnaiba%2Fdockerfiles&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)

**WARN!!** *amd64 & arm64 only*

- [Beanstalkd](https://github.com/users/naiba/packages/container/package/php-fpm) ![Build Status](https://github.com/naiba/Dockerfiles/workflows/beanstalkd/badge.svg) is a lightweight message queue commonly used in PHP.
- [PHP-FPM](https://github.com/users/naiba/packages/container/package/beanstalkd) ![Build Status](https://github.com/naiba/Dockerfiles/workflows/php-fpm/badge.svg) is a PHP-FPM image with integrated ioncube.
- [akshare](https://github.com/users/naiba/packages/container/package/akshare) ![Build Status](https://github.com/naiba/Dockerfiles/workflows/akshare/badge.svg) AKShare docker.
- [wireproxy](https://github.com/users/naiba/packages/container/package/wireproxy) ![Build Status](https://github.com/naiba/Dockerfiles/workflows/wireproxy/badge.svg) wireproxy docker.

## PHP Docker all-in-one

```shell
wget https://github.com/naiba/Dockerfiles/archive/refs/heads/master.zip
unzip master.zip
mv Dockerfiles-master/php-docker-allinone/ ./your-app
rm -rf Dockerfiles-master/ master.zip
cd ./your-app
# edit port/nginx config
nano ./www-data/nginx/virtual-host.conf
nano docker-compose.yaml
docker-compose up -d
```

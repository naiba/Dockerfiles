FROM bitnami/php-fpm:7.4-prod
LABEL maintainer="奶爸 <hi@nai.ba>"

ENV PHP_VERSION=7.4

# Please bind crontab file to /etc/cron.d/crontab-config

RUN install_packages cron && \
    # Install ioncube
    cd /tmp && curl -o ioncube.tar.gz http://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar -xzvf ioncube.tar.gz && \
    cp /tmp/ioncube/ioncube_loader_lin_$PHP_VERSION.so /opt/bitnami/php/lib/php/extensions/ && \
    sed -i 's/;ffi\.preload=/zend_extension = \/opt\/bitnami\/php\/lib\/php\/extensions\/ioncube_loader_lin_7.4.so/g' /opt/bitnami/php/etc/php.ini && \
    rm -rf /tmp/*

CMD chmod 0755 /etc/cron.d/crontab-config && \
    crontab /etc/cron.d/crontab-config && cron f && \
    sleep infinity
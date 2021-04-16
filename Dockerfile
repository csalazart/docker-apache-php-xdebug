FROM php:7-apache

ENV UUID=1000
ENV GUID=120

#RUN useradd -ms /bin/bash www-data
RUN usermod -u $UUID www-data
RUN groupmod -g $GUID www-data

RUN a2enmod rewrite

RUN apt-get update

RUN apt-get install -y git wget curl unzip zip zlib1g-dev libpq-dev git libicu-dev libxml2-dev
RUN docker-php-ext-install pdo pdo_mysql

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN service apache2 restart

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN "date"

ADD ./run.sh / 
RUN chmod +x /run.sh

RUN chown www-data:www-data /var/www/html -Rf
RUN chmod 776 /var/www/html -Rf

USER www-data
WORKDIR /var/www/html

#VOLUME ['/var/www/html']

#RUN /run.sh

#CMD ["/run.sh", "apache2 -D FOREGROUND"]

FROM php:5.6-fpm

# update
RUN apt-get update 

# extension - except: imagick apc xdebug geoip redis
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev
RUN docker-php-ext-install iconv mcrypt mysql mysqli pdo pdo_mysql mbstring gd
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 

# extension - redis
ENV PHP_REDIS_VERSION 2.2.7
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/${PHP_REDIS_VERSION}.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-${PHP_REDIS_VERSION} /usr/src/php/ext/redis \
    && docker-php-ext-install redis
    
RUN usermod -u 1000 www-data

WORKDIR /symfony

EXPOSE 9000

VOLUME ["/user/local/etc/php/conf.d/symfony.ini"]
VOLUME ["/etc/php-fpm.conf"]

CMD ["php-fpm", "-F"]
FROM php:7.2-alpine

#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
RUN apk --no-cache --update add curl \
    vim \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    openssl-dev \
    libmcrypt \
    libmcrypt-dev \
    && docker-php-ext-install \
    # Install the PHP pdo_mysql extension
    pdo_mysql \
    # Install the PHP tokenizer extension
    tokenizer \
    # Install the PHP ZipArchive:
    zip && \
    # Install the PHP gd library
    docker-php-ext-install gd && \
    # Install pcntl and xdebug
    apk add --update --no-cache --virtual .build-deps autoconf build-base php7-pcntl && \
    docker-php-ext-install pcntl && \
    pecl -q install xdebug-2.6.1 pecl-1.0.2 \
    # cleanup
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* \
    && apk del .build-deps

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer && \
    . ~/.bashrc && \
    export COMPOSER_ALLOW_SUPERUSER=1 && \
    composer global require "squizlabs/php_codesniffer=*" hirak/prestissimo \
        --no-interaction --no-progress --no-ansi --no-scripts

####################################
# Final Touches
####################################

WORKDIR /var/www

CMD ["php"]

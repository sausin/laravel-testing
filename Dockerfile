FROM php:7.0-alpine


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
    && docker-php-ext-configure mcrypt \
    && docker-php-ext-install \
    # Install the PHP mcrypt extension
    mcrypt \
    # Install the PHP pdo_mysql extension
    pdo_mysql \
    # Install the PHP tokenizer extension
    tokenizer \
    # Install the PHP ZipArchive:
    zip \
    # Install the PHP gd library
    && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

#####################################
# GD:
#####################################

# Install the PHP gd library
RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

#####################################
# Xdebug:
#####################################

# install autoconf for pecl
RUN apk --update add autoconf build-base php7-pcntl && \
    docker-php-ext-install pcntl

# install xdebug
RUN pecl -q install xdebug-2.6.1


#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer
# Source the bash
RUN . ~/.bashrc

RUN export COMPOSER_ALLOW_SUPERUSER=1
RUN composer global require hirak/prestissimo

####################################
# Final Touches
####################################

WORKDIR /var/www

CMD ["php"]

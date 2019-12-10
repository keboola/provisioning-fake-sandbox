FROM php:7.4-apache
ARG COMPOSER_FLAGS="--prefer-dist --no-interaction"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_PROCESS_TIMEOUT 3600
ENV APP_ENV=prod

WORKDIR /code/

COPY docker/composer-install.sh /tmp/composer-install.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        locales \
        unzip \
    && rm -r /var/lib/apt/lists/* \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && chmod +x /tmp/composer-install.sh \
    && /tmp/composer-install.sh

ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Composer - deps always cached unless changed - First copy only composer files
COPY composer.* /code/

# Download dependencies, but don't run scripts or init autoloaders as the app is missing
WORKDIR /code/
RUN composer install $COMPOSER_FLAGS --no-scripts --no-autoloader

COPY docker/sync-api.conf /etc/apache2/sites-available/
COPY docker/php-prod.ini /usr/local/etc/php/php.ini

# configure apache & php
RUN a2enmod rewrite \	
	&& a2dissite 000-default \ 
	&& a2ensite sync-api \ 
	&& pecl config-set php_ini /usr/local/etc/php.ini

# copy rest of the app
COPY . /code/

# run normal composer - all deps are cached already
RUN composer install $COMPOSER_FLAGS 

ENTRYPOINT []
CMD ["apache2-foreground"]

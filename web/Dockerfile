FROM php:apache

RUN mkdir -p /usr/share/man/man1 \
	&& apt-get update \
	&& apt-get install -y unzip libicu-dev locales libfreetype6-dev \
	libjpeg62-turbo-dev libpng-dev zlib1g-dev libbz2-dev libmagickwand-dev \
	libzip-dev ghostscript wget gnupg2 libgmp-dev \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen \
	&& echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& update-locale LANG=en_US.UTF-8 \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install bz2 \
	&& docker-php-ext-install bcmath \
	&& docker-php-ext-install zip \
	&& docker-php-ext-install gmp \
	&& mkdir -p /usr/src/php/ext/imagick \
	&& curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 \
	&& docker-php-ext-install imagick \
	&& docker-php-ext-install exif \
	&& pecl install xdebug && docker-php-ext-enable xdebug \
	&& a2enmod rewrite && a2enmod ssl && a2ensite default-ssl \
	&& wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
	&& echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list \
	&& apt-get update && apt-get install -y elasticsearch \
	&& apt-get install -y openjdk-11-jdk

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

ARG LOCAL_USER_ID=1000
ARG LOCAL_GROUP_ID=1000

RUN groupadd --gid ${LOCAL_USER_ID} --non-unique xenforo \
	&& useradd --uid ${LOCAL_USER_ID} --gid ${LOCAL_GROUP_ID} --non-unique --shell /sbin/nologin xenforo \
	&& chown -R xenforo:xenforo /etc/ssl/certs /etc/ssl/private /usr/local/etc/php

USER xenforo:xenforo

COPY --chown=xenforo:xenforo ./docker-files/docker-php-ext-*.ini /usr/local/etc/php/conf.d/
COPY --chown=xenforo:xenforo ./docker-files/localhost.crt /etc/ssl/certs/ssl-cert-snakeoil.pem
COPY --chown=xenforo:xenforo ./docker-files/localhost.key /etc/ssl/private/ssl-cert-snakeoil.key

VOLUME /var/www/html/
VOLUME /var/www/html/src/config.php

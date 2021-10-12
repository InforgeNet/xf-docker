FROM php:apache

RUN apt-get update && apt-get install -y libicu-dev locales libfreetype6-dev \
	libjpeg62-turbo-dev libpng-dev zlib1g-dev libbz2-dev libmagickwand-dev \
	libzip-dev ghostscript wget gnupg2 \
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
	&& mkdir -p /usr/src/php/ext/imagick \
	&& curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 \
	&& docker-php-ext-install imagick \
	&& pecl install xdebug && docker-php-ext-enable xdebug \
	&& a2enmod rewrite && a2enmod ssl && a2ensite default-ssl \
	&& wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
	&& echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list \
	&& apt-get update && apt-get install -y elasticsearch

COPY ./docker-files/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY --chown=www-data:www-data ./upload/ /var/www/html/

RUN mkdir -p /usr/share/man/man1 && apt-get install -y openjdk-11-jdk

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

FROM axllent/mailpit as mailpit
FROM composer:2.6.5 AS composer
FROM php:8.2.12-fpm

# https://pecl.php.net/package/imagick
ENV PHP_IMAGICK_VERSION 3.7.0
ENV PHP_REDIS_VERSION 6.0.2
# Xdebug compatibility: https://xdebug.org/docs/compat
ENV PHP_XDEBUG_VERSION 3.3.0

# Install additional packages.
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# Ghostscript is required for rendering PDF previews
		ghostscript \
# Require to be able to interact with Git, such as clone, pull, and push to the remote repositories from within the container.
    git \
    ssh \
# Required for WP-CLI "wp db" command to run properly that otherwise throws "'mysqlcheck': No such file or directory."
    default-mysql-client \
# Required for Composer to unpack ZIP archives that otherwise throws the following warning:
# As there is no 'unzip' nor '7z' command installed zip files are being unpacked using the PHP zip extension.
# This may cause invalid reports of corrupted archives. Besides, any UNIX permissions (e.g. executable) defined in the archives will be lost.
# Installing 'unzip' or '7z' (21.01+) may remediate them.
    unzip \
    zip \
	; \
	rm -rf /var/lib/apt/lists/*

# Install the PHP extensions.
RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libpng-dev \
		libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	; \
	docker-php-ext-install -j "$(nproc)" \
		bcmath \
		exif \
		gd \
		intl \
		mysqli \
		zip \
	; \
	pecl install "imagick-${PHP_IMAGICK_VERSION}"; \
  pecl install "redis-${PHP_REDIS_VERSION}"; \
  pecl install "xdebug-${PHP_XDEBUG_VERSION}"; \
	docker-php-ext-enable imagick redis xdebug; \
  php -m; \
	rm -r /tmp/pear; \
	\
	extDir="$(php -r 'echo ini_get("extension_dir");')"; \
	[ -d "$extDir" ]; \
# Reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$extDir"/*.so \
		| awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	! { ldd "$extDir"/*.so | grep 'not found'; }; \
# Check for output like "PHP Warning:  PHP Startup: Unable to load dynamic library 'foo' (tried: ...)
	err="$(php --version 3>&1 1>&2 2>&3)"; \
	[ -z "$err" ]

# Set recommended PHP.ini settings (https://secure.php.net/manual/en/opcache.installation.php)
RUN set -eux; \
	docker-php-ext-enable opcache; \
	{ \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
		echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
		echo 'display_errors = Off'; \
		echo 'display_startup_errors = Off'; \
		echo 'log_errors = On'; \
		echo 'error_log = /dev/stderr'; \
		echo 'log_errors_max_len = 1024'; \
		echo 'ignore_repeated_errors = On'; \
		echo 'ignore_repeated_source = Off'; \
		echo 'html_errors = Off'; \
	} > /usr/local/etc/php/conf.d/error-logging.ini

# Install Composer
COPY --from=composer /usr/bin/composer /usr/local/bin/
COPY --from=composer /tmp/keys.* /tmp/
RUN set -eux; \
  chmod +x /usr/local/bin/composer; \
  COMPOSER_HOME=$(composer global config home); \
  mv /tmp/keys* $COMPOSER_HOME; \
  mkdir -p /var/www/.composer; \
  chown -R www-data:www-data /var/www/.composer; \
  composer --ansi --version --no-interaction; \
  composer diagnose;

# Install Mailpit
COPY --from=mailpit /mailpit /usr/local/bin/
RUN set -eux; \
  mailpit -h

# VSCode configs
RUN mkdir -p /var/www/.vscode-server; \
  chown -R www-data:www-data /var/www/.vscode-server

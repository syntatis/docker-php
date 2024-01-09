FROM wordpress:cli-2.9.0 AS wp-cli
FROM ghcr.io/syntatis/php:8.1-fpm

LABEL org.opencontainers.image.description "Image to run WordPress with PHP 8.1. This image includes the WP-CLI, Composer, Node.js, and a few additional packages that may be useful for WordPress development."

ENV NODE_VERSION 20
ENV WP_CORE_DOWNLOAD true
ENV WP_VERSION latest
ENV WP_LOCALE en_US

# Install additional packages.
# The "ghostscript" is required for rendering PDF previews
# The "default-mysql-client" for WP-CLI "wp db" command to run properly that otherwise throws "'mysqlcheck': No such file or directory."
RUN docker-php-serversideup-dep-install-debian 'ghostscript default-mysql-client';

# Install the PHP extensions.
# Required for WordPress: "mysqli"
RUN install-php-extensions 'mysqli'; \
  php -m;

RUN set -eux; \
  mkdir -p /var/www/html; \
  chown -R www-data:www-data /var/www/html

COPY --chmod=755 ./entrypoint.sh /etc/entrypoint.d/70-wp-core-download.sh
COPY --from=wp-cli /usr/local/bin/wp /usr/local/bin/

RUN set -eux; \
  chmod +x /usr/local/bin/wp; \
  mkdir -p /var/www/.wp-cli; \
  chown -R www-data:www-data /var/www/.wp-cli;

COPY --chmod=644 --chown=www-data:www-data ./wp-cli.yml /var/www/.wp-cli/config.yml

RUN wp cli info;

RUN set -eux; \
  apt-get update; \
  apt-get install gnupg -y --no-install-recommends; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list; \
  apt-get update; \
  apt-get install nodejs -y --no-install-recommends; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*; \
  node --version; \
  npm --version;

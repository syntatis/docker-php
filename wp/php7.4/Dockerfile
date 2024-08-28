FROM wordpress:cli-2.11.0 AS wp-cli
FROM ghcr.io/syntatis/php:7.4-fpm

LABEL org.opencontainers.image.description "Image to run WordPress with PHP 7.4. This image includes the WP-CLI, Composer, Node.js, and a few additional packages that may be useful for WordPress development."

ENV WP_CORE_DOWNLOAD=true
ENV WP_VERSION=latest
ENV WP_LOCALE=en_US

# Install additional packages.
# The "ghostscript" is required for rendering PDF previews
# The "default-mysql-client" for WP-CLI "wp db" command to run properly that otherwise throws "'mysqlcheck': No such file or directory."
RUN docker-php-serversideup-dep-install-debian 'ghostscript default-mysql-client';

# Install the PHP extensions.
# Required for WordPress: "mysqli"
RUN install-php-extensions 'mysqli'; \
  php -m;

COPY --chmod=755 entrypoint.sh /etc/entrypoint.d/70-wp-core-download.sh
COPY --from=wp-cli /usr/local/bin/wp /usr/local/bin/

RUN set -eux; \
  mkdir -p /var/www/html; \
  chown -R www-data:www-data /var/www/html

RUN set -eux; \
  chmod +x /usr/local/bin/wp; \
  mkdir -p /var/www/.wp-cli; \
  echo "path: /var/www/html" > /var/www/.wp-cli/config.yml; \
  chown -R www-data:www-data /var/www/.wp-cli; \
  wp cli info;

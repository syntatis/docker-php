FROM axllent/mailpit as mailpit
FROM serversideup/php:8.0-fpm

# Xdebug compatibility: https://xdebug.org/docs/compat
# Use Xdebug for debugging and generating code coverage reports.
ENV PHP_XDEBUG_VERSION 3.3.0

# Install the PHP extensions.
RUN pecl install "xdebug-${PHP_XDEBUG_VERSION}"; \
    docker-php-ext-enable xdebug; \
    php -m;

# VSCode configs
RUN mkdir -p /var/www/.vscode-server; \
  chown -R www-data:www-data /var/www/.vscode-server

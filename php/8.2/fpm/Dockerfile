FROM serversideup/php:beta-8.2-fpm

# Xdebug compatibility: https://xdebug.org/docs/compat
ENV PHP_XDEBUG_VERSION 3.3.0

# Install dependencies.
# Git and SSH are required to be able clone, pull, and push to the remote repositories such as when when developing within
# the container with devcontainer
#
# Unzip is required for Composer to unpack ZIP archives that otherwise throws the following warning:
# As there is no 'unzip' nor '7z' command installed zip files are being unpacked using the PHP zip extension.
# This may cause invalid reports of corrupted archives. Besides, any UNIX permissions (e.g. executable)
# defined in the archives will be lost. Installing 'unzip' or '7z' (21.01+) may remediate them.
RUN docker-php-serversideup-dep-install-debian 'git ssh unzip';

# Install the PHP extensions.
# Xdebug is required for debugging and generating code coverage reports.
RUN install-php-extensions 'xdebug-${PHP_XDEBUG_VERSION}'; \
  php -m;

# VSCode configs
RUN mkdir -p /var/www/.vscode-server; \
  chown -R www-data:www-data /var/www/.vscode-server

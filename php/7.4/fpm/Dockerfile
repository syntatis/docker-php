FROM serversideup/php:7.4-fpm

# Install additional packages.
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    php7.4-xdebug \
# Require to be able to interact with Git, such as clone, pull, and push to the remote repositories
# e.g. when developing within the container with devcontainer
    git \
    ssh \
# Required for Composer to unpack ZIP archives that otherwise throws the following warning:
# As there is no 'unzip' nor '7z' command installed zip files are being unpacked using the PHP zip extension.
# This may cause invalid reports of corrupted archives. Besides, any UNIX permissions (e.g. executable) defined in the archives will be lost.
# Installing 'unzip' or '7z' (21.01+) may remediate them.
    unzip \
	; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
  php -m;

# VSCode configs
RUN mkdir -p /var/www/.vscode-server; \
  chown -R www-data:www-data /var/www/.vscode-server

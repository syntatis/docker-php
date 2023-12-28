FROM wordpress:cli-2.9.0 AS wp-cli
FROM ghcr.io/syntatis/php:8.0-fpm

LABEL org.opencontainers.image.description "Image to run WordPress with PHP 8.0. This image includes the WP-CLI, Composer, Node.js, and a few additional packages that may be useful for WordPress development."

ENV NODE_VERSION 20
ENV WP_VERSION 6.4

COPY --from=wp-cli /usr/local/bin/wp /usr/local/bin/

RUN set -eux; \
  chmod +x /usr/local/bin/wp; \
  mkdir -p /var/www/.wp-cli; \
  chown -R www-data:www-data /var/www/.wp-cli; \
  wp cli info

RUN set -eux; \
  mkdir -p /var/www/html; \
  wp core download \
    --path=/var/www/html \
    --allow-root \
    --version=${WP_VERSION}; \
  chown -R www-data:www-data /var/www/html

RUN set -eux; \
  apt-get update; \
  apt-get install gnupg -y --no-install-recommends; \
  mkdir -p /etc/apt/keyrings; \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list; \
  apt-get update; \
  apt-get install nodejs -y --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  node --version; \
  npm --version; \
  npm install -g bun; \
  bun --version;

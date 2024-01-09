#!/bin/sh

if [ wp core version > /dev/null 2>&1 ]; then
  echo "WordPress is already downloaded.";
  wp core verify-checksums;
else
  echo "WordPress is not yet downloaded.";
  if [ "$WP_CORE_DOWNLOAD" = "true" ]; then
    echo "Downloading WordPress.";
    wp core download --force --version=${WP_VERSION:-latest} --locale=${WP_LOCALE:-en_US} --allow-root;
    wp core verify-checksums;
  fi
fi

#!/bin/bash

# Update package repository
sudo DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y upgrade

# Verify the Nginx Package Repository Sign Key.
sudo DEBIAN_FRONTEND=noninteractive curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Initialize the Nginx Package Repository
sudo DEBIAN_FRONTEND=noninteractive echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# Initialize the PHP & NodeJS Package Repository
sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ondrej/php && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get update && apt-get -y upgrade

# Install NodeJS, NPM & Yarn
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs && npm install -g npm && npm install -g yarn

# Install Nginx, PHP
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nginx \
       php8.2-fpm php8.2-cli php8.2-curl php8.2-mbstring \
       php8.2-mysql php8.2-pgsql php8.2-gd php8.2-bcmath php8.2-readline \
       php8.2-zip php8.2-imap php8.2-xml php8.2-intl php8.2-soap \
       php8.2-memcached php8.2-xdebug php8.2-redis php8.2-sqlite

# Install Composer (PHP Package Dependency Manager)
sudo DEBIAN_FRONTEND=noninteractive php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

# Laravel Installer
sudo DEBIAN_FRONTEND=noninteractive composer global require laravel/installer

# Symfony Installer
sudo DEBIAN_FRONTEND=noninteractive curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
&& apt-get install symdony-cli

sudo DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get -y upgrade \
  && apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start the web server
sudo DEBIAN_FRONTEND=noninteractive service php8.2-fpm start && service nginx start
#!/bin/bash
#Please check the license provided with the script!

install_php_8_1() {

trap error_exit ERR

curl -sSL https://packages.sury.org/php/README.txt | sudo bash

PHPVERSION8="8.1"

install_packages "php$PHPVERSION8-dev php-auth-sasl php$PHPVERSION8-gd php$PHPVERSION8-bcmath php$PHPVERSION8-zip php-mail php-net-dime php-net-url php-pear php-apcu php$PHPVERSION8 php$PHPVERSION8-cli php$PHPVERSION8-common php$PHPVERSION8-curl php$PHPVERSION8-fpm php$PHPVERSION8-intl php$PHPVERSION8-mysql php$PHPVERSION8-soap php$PHPVERSION8-sqlite3 php$PHPVERSION8-xsl php$PHPVERSION8-xmlrpc php-mbstring php-xml php$PHPVERSION8-json php$PHPVERSION8-opcache php$PHPVERSION8-readline php$PHPVERSION8-xml php$PHPVERSION8-mbstring php-memcached php-imagick"

#cp /root/NeXt-Server-Bullseye/configs/php/php.ini /etc/php/$PHPVERSION8/fpm/php.ini
#cp /root/NeXt-Server-Bullseye/configs/php/php-fpm.conf /etc/php/$PHPVERSION8/fpm/php-fpm.conf
#cp /root/NeXt-Server-Bullseye/configs/php/www.conf /etc/php/$PHPVERSION8/fpm/pool.d/www.conf

# Configure APCu
#rm -rf /etc/php/$PHPVERSION8/mods-available/apcu.ini
#rm -rf /etc/php/$PHPVERSION8/mods-available/20-apcu.ini

#überarbeiten
#cp /root/NeXt-Server-Bullseye/configs/php/apcu.ini /etc/php/$PHPVERSION8/mods-available/apcu.ini

#ln -s /etc/php/$PHPVERSION8/mods-available/apcu.ini /etc/php/$PHPVERSION8/mods-available/20-apcu.ini

systemctl -q restart nginx.service
systemctl -q restart php$PHPVERSION8-fpm.service
}
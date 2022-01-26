#!/bin/bash
#Please check the license provided with the script!

install_php_8_0() {

trap error_exit ERR

curl -sSL https://packages.sury.org/php/README.txt | sudo bash

PHPVERSION8="8.0"

install_packages "php$PHPVERSION8-dev php$PHPVERSION8-fpm php-auth-sasl php$PHPVERSION8-gd php$PHPVERSION8-bcmath php$PHPVERSION8-zip php-mail php-net-dime php-net-url php-pear php-apcu php$PHPVERSION8 php$PHPVERSION8-cli php$PHPVERSION8-common php$PHPVERSION8-curl php$PHPVERSION8-fpm php$PHPVERSION8-intl php$PHPVERSION8-mysql php$PHPVERSION8-soap php$PHPVERSION8-sqlite3 php$PHPVERSION8-xsl php$PHPVERSION8-xmlrpc php-mbstring php-xml php$PHPVERSION8-opcache php$PHPVERSION8-readline php$PHPVERSION8-xml php$PHPVERSION8-mbstring php-memcached php-imagick"

sed_replace_word "memory_limit = 128M" "memory_limit = 512M" "/etc/php/$PHPVERSION8/fpm/php.ini"
sed_replace_word "upload_max_filesize = 2M" "upload_max_filesize = 512M" "/etc/php/$PHPVERSION8/fpm/php.ini"

systemctl -q restart nginx.service
systemctl -q restart php$PHPVERSION8-fpm.service
}
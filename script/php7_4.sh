#!/bin/bash
#Please check the license provided with the script!

install_php_7_4() {

trap error_exit ERR

PHPVERSION7="7.4"

install_packages "php$PHPVERSION7-dev php$PHPVERSION7-fpm php-auth-sasl php$PHPVERSION7-gd php$PHPVERSION7-bcmath php$PHPVERSION7-zip php-mail php-net-dime php-net-url php-pear php-apcu php$PHPVERSION7 php$PHPVERSION7-cli php$PHPVERSION7-common php$PHPVERSION7-curl php$PHPVERSION7-fpm php$PHPVERSION7-intl php$PHPVERSION7-mysql php$PHPVERSION7-soap php$PHPVERSION7-sqlite3 php$PHPVERSION7-xsl php$PHPVERSION7-xmlrpc php-mbstring php-xml php$PHPVERSION7-opcache php$PHPVERSION7-readline php$PHPVERSION7-xml php$PHPVERSION7-mbstring php-memcached php-imagick"

sed_replace_word "memory_limit = 128M" "memory_limit = 512M" "/etc/php/$PHPVERSION7/fpm/php.ini"
sed_replace_word "upload_max_filesize = 2M" "upload_max_filesize = 512M" "/etc/php/$PHPVERSION7/fpm/php.ini"
sed_replace_word ";cgi.fix_pathinfo=1" "cgi.fix_pathinfo=1" "/etc/php/$PHPVERSION7/fpm/php.ini"

#uncomment various env -> Nextcloud
sed_replace_word ";env\[HOSTNAME\] = \$HOSTNAME" "env[HOSTNAME] = \$HOSTNAME" "/etc/php/$PHPVERSION7/fpm/pool.d/www.conf"
sed_replace_word ";env\[PATH] = /usr/local/bin:/usr/bin:/bin" "env\[PATH] = /usr/local/bin:/usr/bin:/bin" "/etc/php/$PHPVERSION7/fpm/pool.d/www.conf"
sed_replace_word ";env\[TMP] = /tmp" "env\[TMP] = /tmp" "/etc/php/$PHPVERSION7/fpm/pool.d/www.conf"
sed_replace_word ";env\[TMPDIR] = /tmp" "env\[TMPDIR] = /tmp" "/etc/php/$PHPVERSION7/fpm/pool.d/www.conf"
sed_replace_word ";env\[TEMP] = /tmp" "env\[TEMP] = /tmp" "/etc/php/$PHPVERSION7/fpm/pool.d/www.conf"

systemctl -q restart nginx.service
systemctl -q restart php$PHPVERSION7-fpm.service
}
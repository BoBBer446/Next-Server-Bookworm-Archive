#!/bin/bash
#Please check the license provided with the script!

install_phpmyadmin() {

trap error_exit ERR

source /root/NeXt-Server-Bullseye/configs/sources.cfg

MYSQL_ROOT_PASS=$(grep -Pom 1 "(?<=^MYSQL_ROOT_PASS: ).*$" /root/NeXt-Server-Bullseye/login_information.txt)

PMA_HTTPAUTH_USER=$(username)
MYSQL_PMADB_USER=$(username)
MYSQL_PMADB_NAME=$(username)
PMA_HTTPAUTH_PASS=$(password)
PMADB_PASS=$(password)
PMA_BFSECURE_PASS=$(password)

cd /var/www/${MYDOMAIN}/public/
export COMPOSER_ALLOW_SUPERUSER=1
composer create-project phpmyadmin/phpmyadmin --repository-url=https://www.phpmyadmin.net/packages.json --no-dev

if [ "${PHPMYADMIN_PATH_NAME}" == "phpmyadmin" ]; then
	echo "phpmyadmin path unchanged" >>"${main_log}" 2>>"${err_log}"
else
	mkdir -p /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}
	mv phpmyadmin/* /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/
	rm -R /var/www/${MYDOMAIN}/public/phpmyadmin/
fi

htpasswd -b /etc/nginx/htpasswd/.htpasswd ${PMA_HTTPAUTH_USER} ${PMA_HTTPAUTH_PASS}

mkdir -p /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/{save,upload}
chmod 0700 /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/save
chmod g-s /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/save
chmod 0700 /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/upload
chmod g-s /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/upload
mysql -u root -p${MYSQL_ROOT_PASS} mysql < /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/sql/create_tables.sql

cp /root/NeXt-Server-Bullseye/configs/pma/config.inc.php /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/config.inc.php
sed_replace_word "PMA_BFSECURE_PASS" "${PMA_BFSECURE_PASS}" "/var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/config.inc.php"

cp /root/NeXt-Server-Bullseye/addons/vhosts/_phpmyadmin.conf /etc/nginx/_phpmyadmin.conf
sed_replace_word "#include _phpmyadmin.conf;" "include _phpmyadmin.conf;" "/etc/nginx/sites-available/${MYDOMAIN}.conf"
sed_replace_word "change_path" "${PHPMYADMIN_PATH_NAME}" "/etc/nginx/_phpmyadmin.conf"
sed_replace_word "MYDOMAIN" "${MYDOMAIN}" "/etc/nginx/_phpmyadmin.conf"

chown -R www-data:www-data /var/www/${MYDOMAIN}/public/${PHPMYADMIN_PATH_NAME}/

systemctl -q restart php$PHPVERSION7-fpm.service
systemctl -q reload nginx.service

touch /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "--------------------------------------------" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "phpmyadmin" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "--------------------------------------------" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "https://${MYDOMAIN}/${PHPMYADMIN_PATH_NAME}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "PMA_HTTPAUTH_USER = ${PMA_HTTPAUTH_USER}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "PMA_HTTPAUTH_PASS = ${PMA_HTTPAUTH_PASS}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "MYSQL_USERNAME: root" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "MYSQL_ROOT_PASS: $MYSQL_ROOT_PASS" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "MYSQL_PMADB_USER = ${MYSQL_PMADB_USER}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "MYSQL_PMADB_NAME = ${MYSQL_PMADB_NAME}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "PMADB_PASS = ${PMADB_PASS}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
echo "blowfish_secret = ${PMA_BFSECURE_PASS}" >> /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt

sed_replace_word "PMA_IS_INSTALLED=\"0"\" "PMA_IS_INSTALLED=\"1"\" "/root/NeXt-Server-Bullseye/configs/userconfig.cfg"
echo "${PHPMYADMIN_PATH_NAME}" >> /root/NeXt-Server-Bullseye/configs/blocked_paths.conf

dialog_msg "Please save the shown login information on next page"
cat /root/NeXt-Server-Bullseye/phpmyadmin_login_data.txt
continue_or_exit
}
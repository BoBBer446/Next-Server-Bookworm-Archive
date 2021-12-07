#!/bin/bash
#Please check the license provided with the script!
# thx to https://gist.github.com/bgallagh3r

deinstall_nextcloud() {

trap error_exit ERR

MYSQL_ROOT_PASS=$(grep -Pom 1 "(?<=^MYSQL_ROOT_PASS: ).*$" /root/NeXt-Server-Bullseye/login_information.txt)
NextcloudDBName=$(grep -Pom 1 "(?<=^NextcloudDBName = ).*$" /root/NeXt-Server-Bullseye/nextcloud_login_data.txt)
NextcloudDBUser=$(grep -Pom 1 "(?<=^NextcloudDBUser = ).*$" /root/NeXt-Server-Bullseye/nextcloud_login_data.txt)

mysql -u root -p${MYSQL_ROOT_PASS} -e "DROP DATABASE IF EXISTS ${NextcloudDBName};"
mysql -u root -p${MYSQL_ROOT_PASS} -e "DROP USER ${NextcloudDBUser}@localhost;"

rm -rf /var/www/${MYDOMAIN}/public/${NEXTCLOUD_PATH_NAME}
rm /root/NeXt-Server-Bullseye/nextcloud_login_data.txt
rm /etc/nginx/_nextcloud.conf
sed_replace_word "include _nextcloud.conf;" "#include _nextcloud.conf;" "/etc/nginx/sites-available/${MYDOMAIN}.conf"

systemctl -q restart php$PHPVERSION7-fpm.service
systemctl -q restart nginx.service

sed_replace_word "$NEXTCLOUD_PATH_NAME" "" "/root/NeXt-Server-Bullseye/configs/blocked_paths.conf"
sed_replace_word "NEXTCLOUD_PATH_NAME=\".*"\" "NEXTCLOUD_PATH_NAME=\"0"\" "/root/NeXt-Server-Bullseye/configs/userconfig.cfg"
sed_replace_word "NEXTCLOUD_IS_INSTALLED=\"1"\" "NEXTCLOUD_IS_INSTALLED=\"0"\" "/root/NeXt-Server-Bullseye/configs/userconfig.cfg"
}
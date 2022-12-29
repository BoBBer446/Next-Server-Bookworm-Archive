#!/bin/bash

install_mailserver() {

trap error_exit ERR

systemctl -q stop nginx.service
cd /root/NeXt-Server-Bookworm/sources/acme.sh/
bash acme.sh --set-default-ca --server letsencrypt >>"${main_log}" 2>>"${err_log}" || error_exit
bash acme.sh --issue --debug 2 --standalone -d mail.${MYDOMAIN} -d imap.${MYDOMAIN} -d smtp.${MYDOMAIN} --keylength 4096 >>"${main_log}" 2>>"${err_log}" || error_exit 
ln -s /root/.acme.sh/mail.${MYDOMAIN}/fullchain.cer /etc/nginx/ssl/mail.${MYDOMAIN}.cer
ln -s /root/.acme.sh/mail.${MYDOMAIN}/mail.${MYDOMAIN}.key /etc/nginx/ssl/mail.${MYDOMAIN}.key
systemctl -q start nginx.service

MAILSERVER_DB_PASS=$(password)

echo "#------------------------------------------------------------------------------#" >> /root/NeXt-Server-Bookworm/login_information.txt
echo "MAILSERVER_DB_PASS: $MAILSERVER_DB_PASS" >> /root/NeXt-Server-Bookworm/login_information.txt
echo "#------------------------------------------------------------------------------#" >> /root/NeXt-Server-Bookworm/login_information.txt
echo "" >> /root/NeXt-Server-Bookworm/login_information.txt

sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/root/NeXt-Server-Bookworm/configs/mailserver/database.sql"
mysql -u root -p${MYSQL_ROOT_PASS} mysql < /root/NeXt-Server-Bookworm/configs/mailserver/database.sql

mysql -u root -p${MYSQL_ROOT_PASS} mysql < /root/NeXt-Server-Bookworm/configs/mailserver/tlspolicies.sql

adduser --gecos "" --disabled-login --disabled-password --home /var/vmail vmail >>"${main_log}" 2>>"${err_log}" || error_exit

mkdir -p /var/vmail/mailboxes
mkdir -p /var/vmail/sieve/global
chown -R vmail /var/vmail
chgrp -R vmail /var/vmail
chmod -R 770 /var/vmail

mysql -u root -p${MYSQL_ROOT_PASS} -e "use vmail; INSERT INTO domains (domain) values ('${MYDOMAIN}');"
}
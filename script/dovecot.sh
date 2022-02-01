#!/bin/bash
#Please check the license provided with the script!

install_dovecot() {

trap error_exit ERR

###dirty
dpkg -i /root/NeXt-Server-Bullseye/includes/ssl-cert_1.1.2_all.deb >>"${main_log}" 2>>"${err_log}" || error_exit

install_packages "dovecot-core dovecot-imapd dovecot-lmtpd dovecot-mysql dovecot-sieve dovecot-managesieved"

systemctl stop dovecot
mkdir -p /etc/dovecot
rm -r /etc/dovecot/*
cd /etc/dovecot

openssl dhparam -out /etc/dovecot/dh.pem 4096 >/dev/null 2>&1
cp /root/NeXt-Server-Bullseye/configs/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
sed_replace_word "domain.tld" "${MYDOMAIN}" "/etc/dovecot/dovecot.conf"

cp /root/NeXt-Server-Bullseye/configs/dovecot/dovecot-sql.conf /etc/dovecot/dovecot-sql.conf
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/dovecot/dovecot-sql.conf"
chmod 440 /etc/dovecot/dovecot-sql.conf

cp /root/NeXt-Server-Bullseye/configs/dovecot/sieve/* /var/vmail/sieve/global/
}
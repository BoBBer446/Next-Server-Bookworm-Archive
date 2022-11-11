#!/bin/bash
#Please check the license provided with the script!

install_postfix() {

trap error_exit ERR

install_packages "postfix postfix-mysql"

systemctl stop postfix

cd /etc/postfix
rm -r sasl
rm master.cf main.cf.proto master.cf.proto

openssl dhparam -out /etc/postfix/dh.pem 2048 >/dev/null 2>&1
cp /root/NeXt-Server-Bookworm/configs/postfix/main.cf /etc/postfix/main.cf
sed_replace_word "domain.tld" "${MYDOMAIN}" "/etc/postfix/main.cf"
sed_replace_word "IPADR" "${IPADR}" "/etc/postfix/main.cf"
sed_replace_word "IP6ADR" "${IP6ADR}" "/etc/postfix/main.cf"

cp /root/NeXt-Server-Bookworm/configs/postfix/master.cf /etc/postfix/master.cf
cp /root/NeXt-Server-Bookworm/configs/postfix/submission_header_cleanup /etc/postfix/submission_header_cleanup

mkdir -p /etc/postfix/sql
cp -R /root/NeXt-Server-Bookworm/configs/postfix/sql/* /etc/postfix/sql/
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/postfix/sql/accounts.cf"
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/postfix/sql/aliases.cf"
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/postfix/sql/domains.cf"
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/postfix/sql/recipient-access.cf"
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/postfix/sql/sender-login-maps.cf"
sed_replace_word "placeholder" "${MAILSERVER_DB_PASS}" "/etc/postfix/sql/tls-policy.cf"
chown -R root:postfix /etc/postfix/sql
chmod g+x /etc/postfix/sql

touch /etc/postfix/without_ptr
postmap /etc/postfix/without_ptr
newaliases

rm /etc/postfix/./makedefs.out; ln /usr/share/postfix/makedefs.out /etc/postfix/./makedefs.out
}

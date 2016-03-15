#!/bin/sh

set -e

if [[ ! -f /var/lib/ldap/DB_CONFIG ]]; then
  cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
fi

chown -R ldap:ldap /var/lib/ldap /etc/openldap/slapd.d

if [[ ! -z "$MAX_NOFILE" ]]; then
  ulimit -n $MAX_NOFILE
fi


if [ ! -f /etc/nginx/nginx.conf ]
then
    cp -r /etc/nginx.default/* /etc/nginx
fi

NGINX=/usr/sbin/nginx

# show Version and compile config
$NGINX -V

# test config
#$NGINX -t

$NGINX -g "daemon on;"


exec slapd -d 3000 -u ldap -g ldap -h "$SLAPD_URL"


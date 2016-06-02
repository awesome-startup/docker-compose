#!/bin/bash

sed -i 's@^exclude@#exclude@' /etc/yum.conf
yum clean all
yum makecache

yum check-update

# upgrade OS
yum -y upgrade

# install needed packages
for Package in deltarpm gcc gcc-c++ make cmake autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel libaio readline-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5-devel libidn libidn-devel openssl openssl-devel libxslt-devel libicu-devel libevent-devel libtool libtool-ltdl bison gd-devel vim-enhanced pcre-devel zip unzip ntpdate sysstat patch bc expect rsync git lsof lrzsz
do
    yum -y install $Package
done

yum -y update bash openssl glibc

# use gcc-4.4
if [ -n "`gcc --version | head -n1 | grep '4\.1\.'`" ];then
    yum -y install gcc44 gcc44-c++ libstdc++44-devel
    export CC="gcc44" CXX="g++44"
fi

# close SELINUX
setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config

# PS1
[ -z "`cat /etc/bashrc | grep ^PS1`" ] && echo 'PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ "' >> /etc/bashrc 

# history size 
sed -i 's/^HISTSIZE=.*$/HISTSIZE=100/' /etc/profile
[ -z "`cat ~/.bashrc | grep history-timestamp`" ] && echo "export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });user=\$(whoami); echo \$(date \"+%Y-%m-%d %H:%M:%S\"):\$user:\`pwd\`/:\$msg ---- \$(who am i); } >> /tmp/\`hostname\`.\`whoami\`.history-timestamp'" >> ~/.bashrc

# /etc/security/limits.conf
[ -e /etc/security/limits.d/*nproc.conf ] && rename nproc.conf nproc.conf_bk /etc/security/limits.d/*nproc.conf
sed -i '/^# End of file/,$d' /etc/security/limits.conf
cat >> /etc/security/limits.conf <<EOF
# End of file
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
[ -z "`grep 'ulimit -SH 65535' /etc/rc.local`" ] && echo "ulimit -SH 65535" >> /etc/rc.local

# set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Macau /etc/localtime

# /etc/sysctl.conf
sed -i 's/net.ipv4.tcp_syncookies.*$/net.ipv4.tcp_syncookies = 1/g' /etc/sysctl.conf
[ -z "`cat /etc/sysctl.conf | grep 'fs.file-max'`" ] && cat >> /etc/sysctl.conf << EOF
fs.file-max=65535
net.ipv4.tcp_fin_timeout = 30 
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 65536 
net.ipv4.tcp_max_tw_buckets = 20000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 65535 
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 262144
EOF
sysctl -p

sed -i 's@LANG=.*$@LANG="en_US.UTF-8"@g' /etc/locale.conf 
init q

# update time
ntpdate pool.ntp.org 
[ -z "`grep 'ntpdate' /var/spool/cron/root`" ] && { echo "*/20 * * * * `which ntpdate` pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root;chmod 600 /var/spool/cron/root; }
service crond restart
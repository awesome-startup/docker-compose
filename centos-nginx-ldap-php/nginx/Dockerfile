FROM centos:7

MAINTAINER Paul <paul@wizmacau.com>

# Install EPEL
RUN yum install -y epel-release && yum clean all

# Update RPM Packages
RUN yum -y update && yum clean all

# Install Nginx
RUN yum install -y nginx && yum clean all

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# be backwards compatible with pre-official images
RUN ln -sf ../share/nginx /usr/local/nginx

# ldap
RUN yum install -y openldap-servers openldap-clients

# php
RUN yum install -y php

# prepare container
ADD prepare.sh /prepare.sh
RUN chmod 755 /prepare.sh
RUN /prepare.sh

# add startup script
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

ENV SLAPD_URL ldapi:/// ldap:///

VOLUME ["/etc/nginx"]
VOLUME ["/usr/share/nginx/html"]
VOLUME ["/var/www"]

EXPOSE 80 443 389

CMD /startup.sh

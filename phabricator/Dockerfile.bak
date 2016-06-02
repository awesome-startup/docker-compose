FROM centos:7

MAINTAINER Paul <paul@wizmacau.com>

# Install EPEL
RUN yum install -y epel-release 

# Update RPM Packages
RUN yum -y update

# Install Nginx
RUN yum install -y nginx git

WORKDIR /phabricator

RUN git clone https://github.com/phacility/libphutil.git && \
    git clone https://github.com/phacility/arcanist.git && \
    git clone https://github.com/phacility/phabricator.git

RUN export PATH="$PATH:/somewhere/arcanist/bin/"
  
RUN yum install pcre-devel

RUN yum install php-pear && pecl install apc

RUN yum clean all
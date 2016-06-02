FROM centos:7

ADD ./script /usr/local/script

RUN chmod +x /usr/local/script/*.sh

RUN /usr/local/script/centos7_init.sh

# Expose nginx on port 80 and 443
EXPOSE 80
EXPOSE 443
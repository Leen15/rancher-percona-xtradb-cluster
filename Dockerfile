FROM ubuntu:14.04

MAINTAINER Manel Martinez <manel@nixelsolutions.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://repo.percona.com/apt trusty main" > /etc/apt/sources.list.d/percona.list
RUN echo "deb-src http://repo.percona.com/apt trusty main" >> /etc/apt/sources.list.d/percona.list

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
RUN apt-get update && \
    apt-get -y install percona-xtradb-cluster-56 pwgen supervisor

RUN mkdir -p /var/log/supervisor

ENV PXC_MULTICAST_ADDRESS **ChangeMe**
ENV PXC_BOOTSTRAP **ChangeMe**
ENV PXC_SST_PASSWORD **ChangeMe**
ENV PXC_ROOT_PASSWORD **ChangeMe**
ENV CREATE_DATABASES **ChangeMe**

ENV PXC_VOLUME /var/lib/mysql
ENV PXC_CONF /etc/mysql/conf.d/pxc.cnf
ENV PXC_CONF_FLAG /etc/pxc.configured

VOLUME ["${PXC_VOLUME}"]

RUN mkdir -p /usr/local/bin
ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh
ADD ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./etc/supervisord_bootstrap.conf /etc/supervisor/conf.d/supervisord_bootstrap.conf
ADD ./etc/mysql/conf.d/pxc.cnf /etc/mysql/conf.d/pxc.cnf

CMD ["/usr/local/bin/run.sh"]
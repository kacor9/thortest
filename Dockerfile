FROM fedora:latest

FROM php:7.3-apache

USER root

RUN mkdir /tmp/src

COPY . /tmp/src

RUN chown -R 1001:0 /tmp/src

RUN mkdir /ibmdriver
RUN curl https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz | tar -xzf - -C /ibmdriver/
ENV IBM_DB_HOME=/ibmdriver/clidriver
ENV LD_LIBRARY_PATH=/ibmdriver/clidriver/lib

RUN chown -R 1001:0 /ibmdriver

RUN yum -y update
RUN yum -y --skip-broken install php*

RUN pear config-set php_ini "/usr/local/etc/php.ini"
RUN pecl install ibm_db2

#RUN cp -f /usr/lib64/php/modules/ibm_db2.so /usr/lib64/php/modules/mysqli.so

RUN cat /usr/local/etc/php.ini

RUN php -i

USER 1001

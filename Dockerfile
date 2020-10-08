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

RUN pear config-set php_ini "/etc/php.ini"
RUN pecl install ibm_db2

EXPOSE 8080

USER 1001

#RUN echo "extension=ibm_db2.so" >> /etc/php.ini
#RUN tail /etc/php.ini

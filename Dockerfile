FROM ubi8/php-73:latest

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

RUN pear config-set php_ini "/etc/php.ini"
RUN pecl install ibm_db2

RUN cp -f /usr/lib64/php/modules/ibm_db2.so /usr/lib64/php/modules/mysqli.so

EXPOSE 8080

USER 1001

RUN /usr/libexec/s2i/assemble

#RUN echo "extension=ibm_db2.so" >> /etc/php.ini
#RUN tail /etc/php.ini

CMD /usr/libexec/s2i/run

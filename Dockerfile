

# Download latest Fedora base image

FROM fedora:latest

# Work as root

USER root

# Copy website contents to the home folder

COPY . /var/www/html

RUN chown -R 1001:0 /var/www/html

# Install latest updates for Fedora & neccessary packages (PHP, MySQLi, Apache & development)

RUN yum -y update

RUN yum -y --skip-broken install httpd php php-common php-devel php-mysqli php-pdo php-xml php-json php-gd php-mbstring php-pear php-fpm make re2c gcc-c++ gcc unixODBC-devel libxcrypt-compat libnsl

# Download and install IBM DB2 ODBC (need for PHP driver)

RUN mkdir /ibmdriver

RUN curl https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz | tar -xzf - -C /ibmdriver/

RUN chown -R 1001:0 /ibmdriver

# Download and install Oracle Client (need for PHP driver)

RUN curl https://download.oracle.com/otn_software/linux/instantclient/19800/oracle-instantclient19.8-basic-19.8.0.0.0-1.x86_64.rpm --output /tmp/oracle-instantclient19.8-basic-19.8.0.0.0-1.x86_64.rpm

RUN curl https://download.oracle.com/otn_software/linux/instantclient/19800/oracle-instantclient19.8-devel-19.8.0.0.0-1.x86_64.rpm --output /tmp/oracle-instantclient19.8-devel-19.8.0.0.0-1.x86_64.rpm

RUN yum -y install /tmp/oracle*.rpm

# Setup environment variables (need for the drivers)

ENV IBM_DB_HOME=/ibmdriver/clidriver

ENV LD_LIBRARY_PATH=/ibmdriver/clidriver/lib

ENV CLIENT_HOME=/usr/lib/oracle/19.8/client64

ENV ORACLE_HOME=/usr/lib/oracle/19.8/client64

ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib

ENV PATH=$PATH:$ORACLE_HOME/bin

# Install DB2, MSSQL & Oracle database driver for PHP

RUN pecl channel-update pecl.php.net

RUN pear config-set php_ini "/etc/php.ini"

RUN pecl install ibm_db2

RUN pecl install sqlsrv

RUN C_INCLUDE_PATH=/usr/include/oracle/19.8/client64 pecl install oci8 --with-oci8=instantclient,/usr/lib/oracle/19.8/client64/lib

# Configure HTTP daemon

#RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

RUN echo "ServerName requesthor" >> /etc/httpd/conf/httpd.conf

# Enable listen on ports

EXPOSE 8080

EXPOSE 80

# Start the webserver

ENTRYPOINT httpd -DFOREGROUND


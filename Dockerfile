FROM php:8.0-fpm

# Updating and install basic tools
RUN apt-get update -y && \
  apt-get install build-essential libaio1 alien wget -y


# Defining variables to facilitate installation and future updates
ARG INSTANT_CLIENT_URL=https://download.oracle.com/otn_software/linux/instantclient/19600/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm
ARG INSTANT_CLIENT_SDK_URL=https://download.oracle.com/otn_software/linux/instantclient/19600/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm
ARG INSTANT_CLIENT_RPM=oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm
ARG INSTANT_CLIENT_SDK_RPM=oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm
ARG INSTANT_CLIENT_DEB=oracle-instantclient19.6-basic_19.6.0.0.0-2_amd64.deb
ARG INSTANT_CLIENT_SDK_DEB=oracle-instantclient19.6-devel_19.6.0.0.0-2_amd64.deb
ENV ORACLE_HOME=/usr/lib/oracle/19.6/client64
ENV LD_LIBRARY_PATH=/usr/lib/oracle/19.6/client64/lib
#ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/administrador/oracle/oci8–2.1.8/modules:$ORACLE_HOME:$ORACLE_HOME/lib"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$ORACLE_HOME:$ORACLE_HOME/lib"

# Downloading oracle instant client and sdk
RUN wget $INSTANT_CLIENT_URL && wget $INSTANT_CLIENT_SDK_URL

# Install oracle instant client and sdk
RUN alien $INSTANT_CLIENT_RPM && alien $INSTANT_CLIENT_SDK_RPM
RUN dpkg -i $INSTANT_CLIENT_DEB && dpkg -i $INSTANT_CLIENT_SDK_DEB

# RUN export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/administrador/oracle/oci8–2.1.8/modules:$ORACLE_HOME:$ORACLE_HOME/lib"
#RUN export LD_LIBRARY_PATH=$ORACLE_HOME/lib
#RUN export ORACLE_HOME=$ORACLE_HOME

RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Install and activation PDO_OCI and OCI8
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/lib/oracle/19.6/client64/lib
RUN echo instantclient,/usr/lib/oracle/19.6/client64/lib | pecl install oci8
RUN docker-php-ext-install pdo_oci && \
  docker-php-ext-enable oci8

RUN rm $INSTANT_CLIENT_RPM \
  $INSTANT_CLIENT_SDK_RPM \
  $INSTANT_CLIENT_DEB \
  $INSTANT_CLIENT_SDK_DEB

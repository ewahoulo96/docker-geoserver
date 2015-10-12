FROM kartoza/geoserver:latest
MAINTAINER sylviefiat <sylvie.fiat@ird.fr>

ENV GEOSERVER_VERSION 2.6.1

# Install packages
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
 DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
 apt-get -y install wget unzip && \
 apt-get -y install mysql-client && \
 apt-get -y install postgresql-client

# Download mysql extension into /WEB-INF/lib
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-mysql-plugin.zip && \
 unzip  -d /opt/geoserver/webapps/geoserver/WEB-INF/lib/ geoserver-$GEOSERVER_VERSION-mysql-plugin.zip && \
 rm geoserver-$GEOSERVER_VERSION-mysql-plugin.zip

ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/

CMD "/opt/geoserver/bin/startup.sh"
EXPOSE 8080

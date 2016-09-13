FROM tomcat:8.5
MAINTAINER sylviefiat <sylvie.fiat@ird.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

ENV GEOSERVER_VERSION 2.9.1

#Add JAI and ImageIO for great speedy speed.
WORKDIR /tmp
RUN wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
 wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
 gunzip -c jai-1_1_3-lib-linux-amd64.tar.gz | tar xf - && \
 gunzip -c jai_imageio-1_1-lib-linux-amd64.tar.gz | tar xf - && \
 chown -R root:root /tmp/jai-1_1_3/* && \
 chown -R root:root /tmp/jai_imageio-1_1/* && \
 mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/lib/ext/ && \
 mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/lib/amd64/ && \
 mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/lib/ext/ && \
 mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/lib/amd64/ && \
 rm /tmp/jai-1_1_3-lib-linux-amd64.tar.gz && \
 rm -r /tmp/jai-1_1_3 && \
 rm /tmp/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
 rm -r /tmp/jai_imageio-1_1
WORKDIR $CATALINA_HOME

RUN rm -rf /opt/geoserver

# Download Geoserver
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-bin.zip \
 -O /tmp/geoserver.zip; 
RUN unzip /tmp/geoserver.zip -d /opt/ && \
 mv -fT /opt/geoserver-${GEOSERVER_VERSION} /opt/geoserver && \
 chmod -R 777 /opt/geoserver

ENV GEOSERVER_HOME /opt/geoserver
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

RUN mv $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/jai_*.jar /tmp/

# Download mysql extension into /WEB-INF/lib
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-mysql-plugin.zip && \
 unzip  -d $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/ geoserver-$GEOSERVER_VERSION-mysql-plugin.zip && \
 rm geoserver-$GEOSERVER_VERSION-mysql-plugin.zip

CMD $GEOSERVER_HOME/bin/startup.sh
EXPOSE 8080

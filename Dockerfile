FROM openjdk:8-jre
MAINTAINER Ramo <ramo.phoenix7@gmail.com>

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive
ENV TOMCAT_MAJOR_VERSION=8
ENV TOMCAT_VERSION=8.0.32
ENV TOMCAT_HOME=/opt/apache-tomcat-$TOMCAT_VERSION
ENV MYSQL_MAJOR_VERSION=5.6
ENV MYSQL_VERSION=5.6.37

# Install tomcat
RUN mkdir -p $TOMCAT_HOME
RUN cd /opt && wget http://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
	tar xvzf apache-tomcat-$TOMCAT_VERSION.tar.gz && \
	rm -f apache-tomcat-$TOMCAT_VERSION.tar.gz

# Install mysql
RUN apt-get update && apt-get install -y lsb-release libaio1 apt-utils pwgen
RUN mkdir /opt/mysql_temp && cd /opt/mysql_temp && \
	wget https://dev.mysql.com/get/Downloads/MySQL-$MYSQL_MAJOR_VERSION/mysql-server_$MYSQL_VERSION-1debian9_amd64.deb-bundle.tar && \
	tar xvf mysql-server_$MYSQL_VERSION-1debian9_amd64.deb-bundle.tar

RUN dpkg-preconfigure /opt/mysql_temp/mysql-community-server_*.deb
RUN dpkg -i /opt/mysql_temp/mysql-{common,community-client,client,community-server,server}_*.deb; exit 0
RUN apt-get -f -y install && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/mysql_temp


# Adding startup scripts
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY init.sh /init.sh
COPY mysql-setup.sh /mysql-setup.sh
RUN chmod 755 /*.sh

WORKDIR $TOMCAT_HOME

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 8080 3306

ENTRYPOINT ["/init.sh"]


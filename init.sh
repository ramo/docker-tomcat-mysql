#!/bin/bash

/mysql-setup.sh
mysqld --user=mysql &
echo "Starting tomact instance..."
$TOMCAT_HOME/bin/startup.sh &


while true ; do 
	sleep 60
done

#!/bin/bash

# Download TEC GTFS data
echo "Downloading TEC GTFS"
( cd /tmp && curl -O http://gtfs.ovapi.nl/tec/gtfs-tec-20150504.zip )

# Unzip
echo "Unzipping to /tmp/tec-gtfs"
unzip /tmp/gtfs-tec-20150504.zip -d /tmp/gtfs-tec

# Import the data in MySQL-database
echo "Loading the data in database. Wait 1-2 min..."

mysql --local-infile -u root < /vagrant/datasources/tec/importTec.sql

echo "Done!"

# Copy TEC TDT-resources into installed folder
echo "Copy TDT-resources into The DataTank installed folder"
cp -R TECResource ../../tdt/installed

# TODO: install script TDT
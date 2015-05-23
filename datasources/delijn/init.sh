#!/bin/bash

# Download De Lijn GTFS data
echo "Downloading De Lijn GTFS"
( cd /tmp && curl -O http://gtfs.irail.be/de-lijn/de_lijn-gtfs.zip )

# Unzip
echo "Unzipping to /tmp/delijn-gtfs"
unzip /tmp/de_lijn-gtfs.zip -d /tmp/delijn-gtfs

# Import the data in MySQL-database
echo "Loading the data in database. Wait 11min..."

mysql --local-infile -u root < /vagrant/datasources/delijn/importDeLijn.sql

echo "Done!"

# Copy De Lijn TDT-resources into installed folder
echo "Copy TDT-resources into The DataTank installed folder"
cp -R DeLijnResource ../../tdt/installed

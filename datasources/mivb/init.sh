#!/bin/bash

# Download MIVB GTFS data
echo "Downloading MIVB GTFS"
( cd /tmp && curl -O http://gtfs.irail.be/mivb/mivb-gtfs.zip )

# Unzip
echo "Unzipping to /tmp/delijn-gtfs"
unzip /tmp/mivb-gtfs.zip -d /tmp/mivbstib-gtfs

# Import the data in MySQL-database
echo "Loading the data in database. Wait little 2 min..."

mysql --local-infile -u root < /vagrant/datasources/mivb/importMivbStib.sql

echo "Done!"
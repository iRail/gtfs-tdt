# gtfs-tdt
Loads GTFS into MySQL and serves next departures and arrivals at a certain stop from The DataTank

# Setup Vagrant

First step is to install Vagrant and Virtualbox.
See: http://docs.vagrantup.com/v2/getting-started/index.html

Also Chef Development Kit is needed:
See: https://downloads.chef.io/

Next, install Vagrant Librarian so Chef runs automatically
vagrant plugin install vagrant-librarian-chef

Our custom cookbooks are located in vendor/cookbooks.
Librarian fetches all the community cookbook dependencies into it's own directory cookbooks.

Add The Datatank-ip and -hostname to your hosts-file:
192.168.70.70	tdt.hub.dev

# Run

vagrant up [ tdt | db ]

# Acces server 

vagrant ssh tdt|db

# Load Datasources 
Currently are De Lijn and MivbStib included.
Datasources are located in the datasources-folder.

For this example we're going to add De Lijn-datasource. Same principle for MivbStib.

## Run script
This will load all the data.

SSH into the db-environment:
$ vagrant ssh db
Go to De Lijn datasources-folder:
$ cd /vagrant/datasources/delijn

Execute init.sh:
$ ./init.sh

## Install resource into TDT
Go to tdt.hub.dev/api/admin in your favourite browser.
Default credentials are:
user: admin
password: admin

Now let's create an API for De Lijn Departures:
![Picture of Adding Departure API for De Lijn](https://github.com/brechtvdv/gtfs-tdt/master/assets/AddDeLijnDepartures.png "Add Departure")

You will have to now construct the request towards the expected departures at a bus stop yourself. For example, for 2015-05-10T12:00, for Aalst Gentsestraat, you’ll have to construct: http://tdt.hub.dev/delijn/departures/Aalst%20Gentsestraat/2015/05/10/12/00.json



GTFS-TDT
========

Loads GTFS into MySQL and serves next departures and arrivals at a certain stop from The DataTank.

Requirements:
-------------

* Virtualbox
* Vagrant >= 1.7.0
* vagrant-omnibus plugin

Installation:
-------------

Download and install [VirtualBox](http://www.virtualbox.org/)

Download and install [vagrant](http://vagrantup.com/)

Install [vagrant-omnibus](https://github.com/chef/vagrant-omnibus) plugin

    $ vagrant plugin install vagrant-omnibus

Clone this repository

Go to the repository folder and launch the box

    $ cd [repo]
    $ berks vendor
    $ vagrant up

Add The Datatank-ip and -hostname to your hosts-file:

192.168.70.70	tdt.hub.dev

Load datasources:
-----------------

Currently are De Lijn and MivbStib included.
Datasources are located in the datasources-folder.

For this example we're going to add De Lijn-datasource. Same principle for MivbStib.

### Acces server

`vagrant ssh`

### Load data

Go to De Lijn datasources-folder:
`cd /vagrant/datasources/delijn`

Execute init.sh:
`./init.sh`

### Install resource into The DataTank
Go to tdt.hub.dev/api/admin in your favourite browser.
Default credentials are:
user: admin
password: admin

Now let's create an API for De Lijn Departures:
![Picture of Adding Departure API for De Lijn](https://raw.githubusercontent.com/brechtvdv/gtfs-tdt/master/assets/AddDeLijnDepartures.png "Add Departure")

You will have to now construct the request towards the expected departures at a bus stop yourself. For example, for 2015-05-10T12:00, for Aalst Gentsestraat, you’ll have to construct: http://tdt.hub.dev/delijn/departures/Aalst%20Gentsestraat/2015/05/10/12/00.json



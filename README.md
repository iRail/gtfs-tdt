# gtfs-tdt
Loads GTFS into MySQL and serves next departures and arrivals at a certain stop from The DataTank

# Install

First step is to install Vagrant and Virtualbox.
See: http://docs.vagrantup.com/v2/getting-started/index.html

Also Chef Development Kit is needed:
See: https://downloads.chef.io/

Next, install Vagrant Librarian so Chef runs automatically
vagrant plugin install vagrant-librarian-chef

Our custom cookbooks are located in vendor/cookbooks.
Librarian fetches all the community cookbook dependencies into it's own directory cookbooks.

vagrant plugin install vagrant-bindfs

# Run

vagrant up [ tdt | db ]

# Acces server 

vagrant ssh tdt|db



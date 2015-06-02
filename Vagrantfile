# -*- mode: ruby -*-
# vi: set ft=ruby :

tdt_ip                   = "192.168.70.70"
tdt_hostname             = "tdt.hub.dev"

Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/ubuntu-14.04"

  if Vagrant.has_plugin? 'vagrant-omnibus'
    # Set Chef version for Omnibus
    config.omnibus.chef_version = :latest
  else
    raise Vagrant::Errors::VagrantError.new,
      "vagrant-omnibus missing, please install the plugin:\n" +
      "vagrant plugin install vagrant-omnibus"
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: tdt_ip
  config.vm.hostname = tdt_hostname  

  # Use NFS for the shared folder
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  # Provider-specific configuration so you can fine-tune VirtualBox for Vagrant.
  # These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM.
    # For example to change memory or number of CPUs:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

  # Enable provisioning with chef zero, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = ["berks-cookbooks", "cookbooks"] 

    # List of recipes to run
    chef.add_recipe "the_datatank"
    # chef.add_recipe "the_datatank::nodejs"
  end
end

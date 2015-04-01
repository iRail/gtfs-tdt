# -*- mode: ruby -*-
# vi: set ft=ruby :

tdt_ip                   = "192.168.70.70"
tdt_hostname             = "tdt.hub.dev"
db_ip                    = "192.168.70.71"

VAGRANTFILE_API_VERSION = "2"

WINDOWS = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/) ? true : false

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # This is the machine containing the databases
  config.vm.define "db" do |db|
    # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
    db.vm.box = "ubuntu/trusty64"

    # Configurate the virtual machine to use 2GB of RAM
    db.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    db.vm.network :private_network, ip: db_ip
    db.vm.hostname = "db"
    
    # Use Chef Solo to provision our virtual machine
    db.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["cookbooks", "vendor/cookbooks"]

      chef.add_recipe "apt"
      chef.add_recipe "curl"
      chef.add_recipe "tmux"
      chef.add_recipe "vim"
      chef.add_recipe "postgis"
      chef.add_recipe "git"

      chef.add_recipe "db"

      # chef debug level, start vagrant like this to debug:
      # $ CHEF_LOG_LEVEL=debug vagrant <provision or up>
      chef.log_level = ENV['CHEF_LOG'] || "info"
            
      host_ip = db_ip[/(.*\.)\d+$/, 1] + "1"
      
      chef.json = {
        :host_ip => host_ip,
        :xdebug_enabled => true,
        :xdebug_remote_enable => "1",
        :xdebug_remote_port => "9000",
        :xdebug_profiler_output_dir => "/vagrant/xdebug",
        :xdebug_trace_output_dir => "/vagrant/xdebug",
      }
    end
  end

  # This is the machine container a The DataTank installation
  config.vm.define "tdt" do |tdt|
    # Use Ubuntu 14.04 Trusty Tahr 64-bit as our operating system
    tdt.vm.box = "ubuntu/trusty64"

    # Configurate the virtual machine to use 2GB of RAM
    tdt.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    # tdt.vm.synced_folder ".", "/vagrant", :nfs => !WINDOWS
    tdt.vm.synced_folder ".", "/vagrant", type: "nfs"

    tdt.vm.network :private_network, ip: tdt_ip
    tdt.vm.hostname = tdt_hostname

    # Use Chef Solo to provision our virtual machine
    tdt.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["cookbooks", "vendor/cookbooks"]

      chef.add_recipe "apt"
      chef.add_recipe "curl"
      chef.add_recipe "git"
      chef.add_recipe "vim"
      chef.add_recipe "php"
      chef.add_recipe "nodejs"
      chef.add_recipe "memcached"
      chef.add_recipe "apache2"
      chef.add_recipe "build-essential"
      chef.add_recipe "openssl"

      chef.add_recipe "tdt"

      # chef debug level, start vagrant like this to debug:
      # $ CHEF_LOG_LEVEL=debug vagrant <provision or up>
      chef.log_level = ENV['CHEF_LOG'] || "info"
      
      host_ip = tdt_ip[/(.*\.)\d+$/, 1] + "1"
      
      chef.json = {
        :host_ip => host_ip,
        :host_name => tdt_hostname,
        :xdebug_enabled => true,
        :xdebug_remote_enable => "1",
        :xdebug_remote_port => "9000",
        :xdebug_profiler_output_dir => "/vagrant/xdebug",
        :xdebug_trace_output_dir => "/vagrant/xdebug"
      }
    end
  end
end

#
# Cookbook Name:: tdt
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# variables
root_pass = 'root'

bash "set default locale to UTF-8" do
  code <<-EOH
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
dpkg-reconfigure locales
EOH
end
#
# dont't prompt for host key verfication (if any)
template "/home/vagrant/.ssh/config" do
  user "vagrant"
  group "vagrant"
  mode "0600"
  source "config"
end

execute "apt-get update"
package "python-software-properties"

bash "Add PPA for latest PHP" do
  code <<-EOH
  sudo add-apt-repository ppa:ondrej/php5
  EOH
end

execute "apt-get update"

# install software we need that is not available in the Chef supermarket
%w(
libapache2-mod-php5
libssl-dev
mysql-server
php5-mcrypt
php5-fpm
php5-mysql
php5-curl
php5-dev
php5-memcache
).each { | pkg | package pkg }


template "/home/vagrant/.bash_aliases" do
  user "vagrant"
  mode "0644"
  source ".bash_aliases.erb"
end

template "/home/vagrant/.bash_profile" do
  user "vagrant"
  group "vagrant"
  source ".bash_profile"
end

execute "a2enmod rewrite"
execute "a2enmod php5"
execute "a2dismod mpm_event" # otherwise error with restarting apache
execute "a2enmod mpm_prefork"

service "apache2" do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end

file "/etc/apache2/sites-enabled/000-default.conf" do
  action :delete
end

template "/etc/apache2/sites-enabled/vhost.conf" do
  user "root"
  mode "0644"
  source "vhost.conf.erb"
  notifies :reload, "service[apache2]"
end

execute "date.timezone = UTC in php.ini?" do
 user "root"
 not_if "grep 'date.timezone = UTC' /etc/php5/cli/php.ini"
 command "echo -e '\ndate.timezone = UTC\n' >> /etc/php5/cli/php.ini"
end

bash "retrieve composer" do
  user "vagrant"
  cwd "/vagrant"
  code <<-EOH
  set -e
  # check if composer is installed
  if [ ! -f composer.phar ]
  then
    curl -s https://getcomposer.org/installer | php
  else
    php composer.phar selfupdate
  fi
  EOH
end

bash "Clone The DataTank repo" do
  user "vagrant"
  cwd "/vagrant"
  code <<-EOH
  set -e
  if [ ! -d tdt ]
  then
    git clone https://github.com/tdt/core.git tdt ;
    chmod -R  777 tdt/app/storage ;
  else
    cd tdt ; git pull ;
  fi
  
  EOH
end

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password root_pass
  action [:create, :start]
end

mysql_config 'default' do
  source 'vhost.conf.erb'
  notifies :restart, 'mysql_service[default]'
  action :create
end

template "/etc/mysql/my.cnf" do
  user "root"
  mode "0644"
  source 'my.cnf'
end

# create database on default
bash 'create database datatank' do
  not_if "echo 'show databases' | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -p#{Shellwords.escape(root_pass)} | grep datatank"
  code <<-EOF
  echo 'CREATE DATABASE datatank;' | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -p#{Shellwords.escape(root_pass)};
  EOF
  action :run
end

# bash "Create database" do
#   user "vagrant"
#   cwd "/vagrant"
#   not_if "echo 'show databases' | mysql -u root | grep datatank"
#   code <<-EOH
#   set -e
#   echo "create database datatank" | mysql -u root
#   EOH
# end

# template "/vagrant/tdt/app/config/database.php" do
#   user "vagrant"
#   group "vagrant"
#   source "database.php"
# end

template "/vagrant/tdt/app/config/database.php" do
  user "root"
  mode "0644"
  source "database.php"
end

template "/vagrant/tdt/app/config/app.php" do
  user "root"
  mode "0644"
  source "app.php"
end

# template "/vagrant/tdt/app/config/app.php" do
#   user "vagrant"
#   group "vagrant"
#   source "app.php"
# end

bash "run composer" do
  cwd "/vagrant/tdt"
  not_if "echo 'show tables' | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -p#{Shellwords.escape(root_pass)} | grep migrations"
  code <<-EOH
  set -e
  export COMPOSER_HOME=/home/vagrant
  ../composer.phar install
  EOH
end
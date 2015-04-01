#
# Cookbook Name:: db
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
root_pass = 'root'

bash "set default locale to UTF-8" do
  code <<-EOH
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
dpkg-reconfigure locales
EOH
end

# dont't prompt for host key verfication (if any)
template "/home/vagrant/.ssh/config" do
  user "vagrant"
  group "vagrant"
  mode "0600"
  source "config"
end


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

execute "apt-get update"
package "python-software-properties"


# install the software we need
%w(
curl
tmux
vim
git
unzip
mysql-server
).each { | pkg | package pkg }

bash "Create mysql database" do
  user "vagrant"
  cwd "/vagrant"
  not_if "echo 'show databases' | mysql -u root | grep datatank"
  code <<-EOH
  set -e
  echo "create database datatank" | mysql -u root
  EOH
end


bash "Grant mysql database access from everywhere" do
  user "root"
  cwd "/vagrant"
  code <<-EOH
  # enable remote access
  # setting the mysql bind-address to allow connections from everywhere
  sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
  MYSQL=`which mysql`
  Q1="GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
  Q2="FLUSH PRIVILEGES;"
  SQL="${Q1}${Q2}"
  $MYSQL -uroot -e "$SQL"
  service mysql restart
  EOH
end
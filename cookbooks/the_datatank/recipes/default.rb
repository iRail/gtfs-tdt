include_recipe "apt"
include_recipe "build-essential"
include_recipe "git"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_apc"
include_recipe "php::module_curl"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "composer"

# Initialize php extensions list
php_extensions = []

# Install packages
%w{ debconf vim screen tmux mc curl make g++ memcached php5-mcrypt }.each do |a_package|
  package a_package
end

# Install php5-mcrypt
execute "Enable php5-mcrypt" do
  command "sudo php5enmod mcrypt"
end

# Generate selfsigned ssl
execute "make-ssl-cert" do
  command "make-ssl-cert generate-default-snakeoil --force-overwrite"
end

# Install Mysql
mysql_service 'default' do
  port node['mysql']['port']
  version node['mysql']['version']
  socket node['mysql']['socket']
  initial_root_password node['mysql']['initial_root_password']
  action [:create, :start]
end
mysql_client 'default' do
  action :create
end
bash "Create mysql datatank-database" do
  user "root"
  cwd "/vagrant"
  not_if "echo 'show databases' | mysql -h 127.0.0.1 -u root -proot| grep datatank"
  code <<-EOH
  set -e
  echo "create database datatank" | mysql -h 127.0.0.1 -u root -proot
  EOH
end

# Install TDT
bash "Clone The DataTank repo" do
  user "root"
  cwd "/vagrant"
  code <<-EOH
  set -e
  if [ ! -d tdt ]
  then
    git clone https://github.com/tdt/core.git tdt ;
  else
    cd tdt ; git pull ;
  fi
  
  EOH
end
apache_conf node['tdt']['name'] do
  enable true
  notifies :restart, resources("service[apache2]"), :delayed
end
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
execute "composer install" do
  cwd "/vagrant/tdt"
  command "composer install && touch /var/log/.php_composer_installed"
  creates "/var/log/.php_composer_installed"
  action :run
end
execute "Give tdt/app/storage 777 permission" do
  cwd "/vagrant"
  user "root"
  command "chmod -R  777 tdt/app/storage"
end   

# Add The DataTank to apache config
web_app node['tdt']['name'] do
  docroot node['apache']['docroot_dir']
  template "#{node['tdt']['config']}.erb"
  notifies :restart, resources("service[apache2]"), :delayed
end

# Create the document root.
directory node['apache']['docroot_dir'] do
  recursive true
end

 # Add site info in /etc/hosts
 bash "hosts" do
   code "echo 127.0.0.1 tdt.hub.dev >> /etc/hosts"
 end

# Disable default site
apache_site "default" do
  enable false
end

# Install php-xsl
package "php5-xsl" do
  action :install
end

# Enable installed php extensions
case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 14.04
      php_extensions.each do |extension|
        execute 'enable_php_extension' do
          command "php5enmod #{extension}"
        end
      end
    end
  else
end
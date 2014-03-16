#
# Cookbook Name:: laravel
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{php php-devel php-mbstring php-mysql php-mcrypt httpd mysql-server}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "install_composer" do
  command "curl -sS https://getcomposer.org/installer | php"
  creates "/composer.phar"
  action :run
end

execute "mv_composer" do
  command "mv /composer.phar /usr/local/bin/composer"
  creates "/usr/local/bin/composer"
  action :run
end

execute "install_laravel" do
 command "composer create-project laravel/laravel project-name --prefer-dist"
 creates "/var/www/html/project-name"
 action :run
end

execute "mv_laravel" do
  command "mv project-name/ /var/www/html/project-name"
  creates "/var/www/html/project-name"
  action :run
end

execute "chmod_laravel_public" do
  command "chmod -R 777 /var/www/html/project-name/app/storage"
  action :run
end

cookbook_file "/etc/httpd/conf/httpd.conf" do
  mode 0644
end

service "httpd" do
  action [ :enable , :start ]
  supports :status => true, :restart => true
end

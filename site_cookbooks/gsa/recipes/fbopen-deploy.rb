#
# Cookbook Name:: gsa
# Recipe:: elasticsearch
#
# Copyright 2015
#
# All rights reserved - Do Not Redistribute
#

$env=node.chef_environment

case node[:platform_family]

when "rhel"	

$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name

bash "Clone FBOpenrepo" do
user "root"
code <<-EOH
	 
     mkdir -p /var/www
     cd /var/www
     git clone https://#{$git_repo}

EOH
not_if {::File.exists?("/var/www/#{$git_repo_name}") }
end

bash "Pull git_repo" do
user "root"
code <<-EOH
	
	cd /var/www
	cd #{$git_repo_name}
	git pull | echo "Already uptodate"
   
EOH
only_if {::File.exists?("/var/www/#{$git_repo_name}") }
end


bash "External dependency on another git repo" do
user "root"
code <<-EOH
    cd /var/www
	cd #{$git_repo_name}
	git submodule update --init --recursive
   
EOH
end


bash "Move static scripts into place" do
user "root"
code <<-EOH
	
	cp -R /var/www/#{$git_repo_name}/elasticsearch/conf/scripts/* /usr/share/elasticsearch/
   
EOH
end

service "elasticsearch" do
  action :restart
end


bash "For devlopment usage" do
user "root"
code <<-EOH
	
	cd /var/www
	cd #{$git_repo_name}/api
	cp config-sample_dev.js config.js
   
EOH
end



service "httpd" do
 action :restart
end


when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

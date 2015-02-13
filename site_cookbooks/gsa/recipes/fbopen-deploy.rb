#
# Cookbook Name:: gsa
# Recipe:: elasticsearch
#
# Copyright 2015
#
# All rights reserved - Do Not Redistribute
#


case node[:platform_family]

when "rhel"	

$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name

bash "Clone FBOpenrepo" do
user "root"
code <<-EOH
	
     mkdir -p /rood/.devops
     git clone https://#{$git_repo}

EOH
not_if {::File.exists?("/rood/.devops/#{$git_repo_name}") }
end

bash "Pull git_repo" do
user "root"
code <<-EOH
	
	cd /rood/.devops
	cd #{$git_repo_name}
	git pull | echo "Already uptodate"
   
EOH
only_if {::File.exists?("/rood/.devops/#{$git_repo_name}") }
end


bash "External dependency on another git repo" do
user "root"
code <<-EOH
	
	git submodule update --init --recursive
   
EOH
end


bash "Move static scripts into place" do
user "root"
code <<-EOH
	
	sudo \cp -R /root/.devops/fbopen/elasticsearch/conf/scripts/* /usr/share/elasticsearch/
   
EOH
end

service "elasticsearch" do
  action :restart
end


execute "curl -XPUT localhost:9200/fbopen0 --data-binary @elasticsearch/init.json" do
 action :run
end

bash "For local usage" do
user "root"
code <<-EOH
	
	cd /rood/.devops
	cd #{$git_repo_name}
	sudo \cp config-sample_dev.js config.js
   
EOH
end


when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 
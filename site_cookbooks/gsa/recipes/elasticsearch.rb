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



bash "Install dependancy" do
user "root"
code <<-EOH
	rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch
EOH
end


template '/etc/yum.repos.d/elasticsearch.repo' do
owner 'root'
group 'root'
mode '0644'
source "etc/yum.repos.d/elasticsearch.repo.erb"
end





when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

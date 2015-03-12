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


execute "yum -y install elasticsearch" do
 action :run
end


bash "Install Plugin" do
user "root"
code <<-EOH
    
    cd /usr/share/elasticsearch/
	bin/plugin install elasticsearch/elasticsearch-mapper-attachments/2.4.2 | echo "Plugin already added"

EOH
end


service "elasticsearch" do
  action :restart
end

when "debian"

else

 raise '#{node[:platform_family]} not supported'

end 

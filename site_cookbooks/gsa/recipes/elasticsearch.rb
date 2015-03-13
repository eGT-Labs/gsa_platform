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

# for managing service
# elasticsearch block until operational
ruby_block "block_until_operational" do
  block do
    until IO.popen("netstat -lnt").entries.select { |entry|
        entry.split[3] =~ /:9200$/
      }.size == 1   
      Chef::Log.debug "service[elasticsearch] not listening on port 9200"
      sleep 1
    end
  end
  action :nothing
end

service "elasticsearch" do
  action :restart
  notifies :create, 'ruby_block[block_until_operational]', :immediate
end

when "debian"

else

 raise '#{node[:platform_family]} not supported'

end 

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

git_repo=node.gsa.global.git_repo

bash "Clone FBOpenrepo" do
user "root"
code <<-EOH
	
     mkdir -p /rood/.devops
     git clone https://#{git_repo}

EOH
end


when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

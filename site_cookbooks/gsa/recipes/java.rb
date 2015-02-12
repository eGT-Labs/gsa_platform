#
# Cookbook Name:: gsa
# Recipe:: java
#
# Copyright 2015
#
# All rights reserved - Do Not Redistribute
#


case node[:platform_family]

when "rhel"	



bash "Download Oracal java8" do
user "root"
code <<-EOH
	cd /opt
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.tar.gz"
    tar xzf jdk-8u31-linux-x64.tar.gz
EOH
end




when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

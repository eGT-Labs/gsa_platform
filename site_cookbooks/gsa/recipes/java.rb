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



bash "Install Open Jdk" do
user "root"
code <<-EOH

	yum -y install java-1.7.0-openjdk
	yum -y remove openjdk-6-jre
	yum -y remove java-1.6.0-openjdk

EOH
end



when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

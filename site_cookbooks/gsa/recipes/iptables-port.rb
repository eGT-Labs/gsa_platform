#
# Cookbook Name:: gsa
# Recipe:: iptables-port
#
# Copyright 2015
#
# All rights reserved - Do Not Redistribute
#


case node[:platform_family]

when "rhel"	

ports=node.gsa.global.ports

puts "node.gsa.global.ports #{ports}"




when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

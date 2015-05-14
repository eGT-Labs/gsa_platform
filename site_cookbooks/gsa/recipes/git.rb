#
# Cookbook Name:: gsa
# Recipe:: git 
#



case node[:platform]

	when "centos"
		# The git package comes from EPEL on RHEL-flavored systems
		include_recipe "yum-epel"

	when "ubuntu"


	else
		Chef::Log.info("Unsupported platform #{node[:platform]}")
end


package "git"
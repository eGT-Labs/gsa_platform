#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute

['nodejs', 'nodejs-devel', 'npm', 'git'].each do |pkg|
  package pkg
end

execute "npm install npm -g -y" do
	not_if "npm -v | grep 2.1.2"
end

['block-stream', 'fstream', 'fstream-ignore', 'fstream-npm', 'glob', 'npmconf', 'tar', 'bower', 'gulp'].each do |lib|
	execute "npm install #{lib} -g -y" do
		not_if "npm list -g #{lib} --depth=0 | grep ' #{lib}@'"
	end
end

include_recipe "chef-vault"

$app_dir = "/home/fda-data"
execute "git clone git@github.com:eGT-Labs/egt-gsa-proto.git #{$app_dir}" do
	not_if { File.exists?($app_dir) }
end

	template "/etc/rc.d/init.d/fda-data" do
		source "openfemaapi-init.erb"
		mode '0755'
		owner 'root'
		group 'root'
		variables :details => { :dir => "/home/fda-data", :service => "FDAData" }
#		notifies :restart, "service[fda-data]", :delayed
	end

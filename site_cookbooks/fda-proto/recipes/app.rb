#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute

include_recipe "chef-vault"
build_keys = chef_vault_item("gsa_ssh_keys", "egt-gsa-proto-jenkins")
execute "append build key to root's authorized_keys" do
	command "echo '#{build_keys['public']}' >> /root/.ssh/authorized_keys"
	not_if "grep '^#{build_keys['public']}' /root/.ssh/authorized_keys"
end

['nodejs', 'nodejs-devel', 'npm', 'git'].each do |pkg|
  package pkg
end

execute "npm install npm -g -y" do
	not_if "npm -v | grep 2.1.2"
end

['block-stream', 'fstream', 'fstream-ignore', 'fstream-npm', 'glob', 'npmconf', 'tar', 'bower', 'gulp', 'forever'].each do |lib|
	execute "npm install #{lib} -g -y" do
		not_if "npm list -g #{lib} --depth=0 | grep ' #{lib}@'"
	end
end

include_recipe "chef-vault"

$app_dir = "/home/fda-data"
execute "git clone git@github.com:eGT-Labs/egt-gsa-proto.git #{$app_dir}" do
	not_if { File.exists?($app_dir) }
end

template "/etc/rc.d/init.d/egt-fda-catalyst" do
	source "fda-data-init.erb"
	mode '0755'
	owner 'root'
	group 'root'
	variables(:details => { :dir => "/apps/egt-gsa-proto", :service => "eGT FDA Catalyst Engine" })
	notifies :restart, "service[egt-fda-catalyst]", :delayed
end

service "egt-fda-catalyst" do
	action [:start, :enable]
end

web_app "app" do
  server_name "gsa-fda-proto.egt-labs.com"
  server_aliases [ node.fqdn, node.hostname ]
  docroot "/var/www/html"
  cookbook "fda-proto"
  allow_override "All"
  template "appvhost.conf.erb"
end

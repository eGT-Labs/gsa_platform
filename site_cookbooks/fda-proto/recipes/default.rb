#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute

include_recipe "chef-vault"
ssh_keys = chef_vault_item("gsa_ssh_keys", "egt-gsa-proto-github")

cookbook_file "#{Chef::Config[:file_cache_path]}/jenkins.rpm" do
	source "jenkins-1.617-1.1.noarch.rpm"
end
rpm_package "jenkins" do
	source "#{Chef::Config[:file_cache_path]}/jenkins.rpm"
end

file "/root/.ssh/egt-gsa-proto-github" do
	content ssh_keys['private']
	mode 0400
end

file "/root/.ssh/config" do
  content "Host github.com\n  User git\n  IdentityFile /root/.ssh/egt-gsa-proto-github\n"
	mode 0600
end

execute "ssh-keyscan github.com >> ~/.ssh/known_hosts" do
	not_if "grep github.com ~/.ssh/known_hosts"
end

bash "Allow http through iptables" do
  user "root"
  not_if "/sbin/iptables -nL | egrep '^ACCEPT.*dpt:80($| )'"
  code <<-EOH
    iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    service iptables save
  EOH
end

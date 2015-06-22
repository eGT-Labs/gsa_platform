#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute

include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_deflate"
include_recipe "chef-vault"

# We use Apache to redirect ports and front things with SSL
execute "setsebool -P httpd_can_network_connect on" do
  not_if "getsebool httpd_can_network_connect | grep ' on$'"
  notifies :reload, "service[apache2]", :delayed
end
[80, 443].each { |port|
	bash "Allow #{port} through iptables" do
		user "root"
		not_if "/sbin/iptables -nL | egrep '^ACCEPT.*dpt:#{port}($| )'"
		code <<-EOH
			iptables -I INPUT -p tcp --dport #{port} -j ACCEPT
			service iptables save
		EOH
	end
}
bash "Allow 8080 through iptables" do
	user "root"
	not_if "/sbin/iptables -nL | egrep '^ACCEPT.*dpt:8080($| )'"
	code <<-EOH
		iptables -I INPUT -p tcp -d 127.0.0.1 --dport 8080 -j ACCEPT
		service iptables save
	EOH
end
ssl_cert = chef_vault_item("ssl", "egt-labs-wildcard-cert")
file "/etc/httpd/ssl/egt-labs-wildcard.crt" do
	content ssl_cert['file-content']
	notifies :restart, "service[apache2]", :delayed
end
ssl_key = chef_vault_item("ssl", "egt-labs-wildcard-key")
file "/etc/httpd/ssl/egt-labs-wildcard.key" do
	content ssl_key['file-content']
	notifies :restart, "service[apache2]", :delayed
end
#ssl_cert = chef_vault_item(Chef::Config[:node_name], "ssl_cert")
#file "/etc/httpd/ssl/egt-labs-wildcard.crt" do
#	content ssl_cert['data']['node.crt']
#	mode 0400
#end
#file "/etc/httpd/ssl/egt-labs-wildcard.key" do
#	content ssl_cert['data']['node.key']
#	mode 0400
#end


github_keys = chef_vault_item("gsa_ssh_keys", "egt-gsa-proto-github")

file "/root/.ssh/egt-gsa-proto-github" do
	content github_keys['private']
	mode 0400
end

file "/root/.ssh/config" do
  content "Host github.com\n  User git\n  IdentityFile /root/.ssh/egt-gsa-proto-github\n"
	mode 0600
end

execute "ssh-keyscan github.com >> ~/.ssh/known_hosts" do
	not_if "grep github.com ~/.ssh/known_hosts"
end

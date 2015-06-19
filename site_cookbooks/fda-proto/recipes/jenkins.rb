#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_deflate"

execute "setsebool -P httpd_can_network_connect on" do
  not_if "getsebool httpd_can_network_connect | grep ' on$'"
  notifies :reload, "service[apache2]", :delayed
end

web_app "jenkins" do
  server_name "gsa-fda-proto-jenkins.egt-labs.com"
  server_aliases [ node.fqdn, node.hostname ]
  docroot "/var/www/html"
  cookbook "fda-proto"
  allow_override "All"
  template "jenkinsvhost.conf.erb"
end

jenkins_plugin "slack"
jenkins_plugin "credentials"

bash "Allow http through iptables" do
  user "root"
  not_if "/sbin/iptables -nL | egrep '^ACCEPT.*dpt:8080($| )'"
  code <<-EOH
    iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    service iptables save
  EOH
end

node.deployment.servers.app.each_pair { |node, data|
#	jenkins_ssh_slave node do
#	end
}
package "git"


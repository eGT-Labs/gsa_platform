#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute
#
include_recipe "chef-vault"

web_app "jenkins" do
  server_name "gsa-fda-proto-jenkins.egt-labs.com"
  server_aliases [ node.fqdn, node.hostname ]
  docroot "/var/www/html"
  cookbook "fda-proto"
  allow_override "All"
  template "jenkinsvhost.conf.erb"
end
package "git"

# Their public repo is broken, dance around it for now
cookbook_file "#{Chef::Config[:file_cache_path]}/jenkins.rpm" do
	source "jenkins-1.617-1.1.noarch.rpm"
end
rpm_package "jenkins" do
	source "#{Chef::Config[:file_cache_path]}/jenkins.rpm"
end

["credentials", "scm-api", "github", "github-api", "git", "git-client"].each { |plugin|
	jenkins_plugin plugin do
		not_if { ::File.exists?("/var/lib/jenkins/plugins/#{plugin}.jpi") }
		action :install
	end
}
jenkins_plugin "slack" do
	not_if { ::File.exists?("/var/lib/jenkins/plugins/slack.jpi") }
	notifies :restart, 'service[jenkins]', :delayed
	action :install
end
file "/var/lib/jenkins/jenkins.plugins.slack.SlackNotifier.xml" do
	mode 0640
	owner "jenkins"
	content "<?xml version='1.0' encoding='UTF-8'?>
<jenkins.plugins.slack.SlackNotifier_-DescriptorImpl plugin='slack@1.8'>
  <teamDomain>teamegt</teamDomain>
  <token>NtJWvzNlT0unlTgB5nE9ESHa</token>
  <room></room>
  <buildServerUrl>https://gsa-fda-proto-jenkins.egt-labs.com/</buildServerUrl>
</jenkins.plugins.slack.SlackNotifier_-DescriptorImpl>
"
	notifies :restart, 'service[jenkins]', :delayed
end

github_keys = chef_vault_item("gsa_ssh_keys", "egt-gsa-proto-github")
build_keys = chef_vault_item("gsa_ssh_keys", "egt-gsa-proto-jenkins")

jenkins_private_key_credentials "github" do
	description "GSA FDA Dataset Prototype Github credentials"
	id "7a15c36f-24a0-4967-bb90-0e220ac0f4b6"
	private_key github_keys['private']
end
jenkins_private_key_credentials "root" do
	description "GSA FDA Dataset Prototype build job credentials"
	id "0836e2b3-7f83-4580-95d8-ad2a983e49c8"
	private_key build_keys['private']
end

jenkins_user 'root' do
	full_name "Build Job"
	email "john.stange@eglobaltech.com"
	public_keys [build_keys['public'], github_keys['public']]
end

node.deployment.servers.app.each_pair { |node, data|
	execute "ssh-keyscan #{data.private_ip_address} >> ~/.ssh/known_hosts" do
		not_if "grep #{data.private_ip_address} ~/.ssh/known_hosts"
	end
	jenkins_ssh_slave node.dup do
		host data.private_ip_address
		action :create
		remote_fs "/jenkins"
		labels ['app-server']
		user 'root'
		credentials 'root'
	end
} rescue NoMethodError

template "#{Chef::Config[:file_cache_path]}/egt-gsa-proto-build.xml" do
	source "jenkins-job.xml.erb"
end

jenkins_job "egt-gsa-proto-build" do
	config "#{Chef::Config[:file_cache_path]}/egt-gsa-proto-build.xml"
end

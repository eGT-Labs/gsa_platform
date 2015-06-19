#
# Cookbook Name:: fda-proto
# Recipe:: default
#
# Copyright 2015, eGlobalTech
#
# All rights reserved - Do Not Redistribute

jenkins_plugin "slack"
jenkins_plugin "credentials"


node.deployment.servers.app.each_pair { |node, data|
#	jenkins_ssh_slave node do
#	end
}

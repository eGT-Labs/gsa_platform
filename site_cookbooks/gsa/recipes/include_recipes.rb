#
# Cookbook Name:: gsa
# Recipe:: include_recipes
#
# Copyright 2015
#
# All rights reserved - Do Not Redistribute
#

include_recipe "utility::wget"
include_recipe "utility::git"
include_recipe "apache2"
include_recipe "gsa::java"
include_recipe "gsa::elasticsearch"
include_recipe "gsa::iptables-port"
include_recipe "gsa::nodejs"

include_recipe "gsa::clone_repo"
include_recipe "gsa::deploy_api_server"
include_recipe "gsa::loadder"
include_recipe "gsa::apache"
include_recipe "gsa::web_server_run"

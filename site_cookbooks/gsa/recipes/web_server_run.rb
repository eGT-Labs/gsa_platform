$env=node.chef_environment

$apps_dir=node.gsa.global.apps_dir
$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name


server_url="localhost"


if node.deployment.loadbalancers !=nil
 server_url=node.deployment.loadbalancers.fbopenlb.dns
else
server_url=node.deployment.servers.fbopen.public_ip_address	
end	



case node[:platform_family]

when "rhel"	


service "httpd" do
 action :nothing
end




e = bash "clone html applicatiion" do
user "root"
code <<-EOH
	cd #{$apps_dir}/#{$git_repo_name}/api
	rm -rf /var/www/html/*
    cp -R sample-www/* /var/www/html/
    chown -R apache /var/www/html
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
action :nothing
end

e.run_action(:run)

template "/var/www/html/config.js" do
    source "web_server/config.js.erb"
    mode 0755
    owner "apache"
    group "apache"
    variables({
    	 :server_url => server_url
    	})
    notifies :restart, "service[httpd]", :delayed
end





when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

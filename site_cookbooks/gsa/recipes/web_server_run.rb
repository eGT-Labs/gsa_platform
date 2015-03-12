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







template "#{$apps_dir}/#{$git_repo_name}/sample-www/config.js" do
    source "web_server/config.js.erb"
    mode 0755
    owner "root"
    group "root"
    variables({
    	 :server_url => server_url
    	})
end


service "httpd" do
 action :restart
end


when "debian"



else

 raise '#{node[:platform_family]} not supported'

end 

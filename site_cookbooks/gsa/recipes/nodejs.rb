case node[:platform_family]
		when "rhel"	
			bash "Install nodejs" do
			user "root"
			code <<-EOH
			    yum -y groupinstall "Development Tools" | echo "success"
				cd /usr/src

				rm -rf node-v*
				wget http://nodejs.org/dist/v0.11.8/node-v0.11.8.tar.gz
				tar xzvf node-v* && cd node-v*
				./configure
				make && make install
			EOH
			not_if {::File.exists?("/usr/local/bin/node") && `/usr/local/bin/node --version`.chomp == "v0.11.8" }
			end
		when "debian"
else
 raise '#{node[:platform_family]} not supported'
end 

$service_name = node.service_name;

def get_ec2_attribute(attribute_name)
        attribute_value =nil
        begin
                query="http://169.254.169.254/latest/meta-data/"+attribute_name
                uri = URI(query)
                Chef::Log.info("URI will be #{uri}")
                attribute_value = Net::HTTP.get(uri)
                Chef::Log.info("Retrieved dynamic ec2 value of #{attribute_value} for attribute #{attribute_name}")
        rescue Exception => e
               Chef::Log.info("Error response to dynamic ec2 value retrieve of #{attribute_name} is #{e}")
        end
        attribute_value
end

public_ip=get_ec2_attribute("public-ipv4")


bash "prep nginx files" do
    user "root"
    code <<-EOH
    rm -rf /etc/nginx/nginx.conf
    rm -rf /etc/nginx/sites-available/
    rm -rf /etc/nginx/sites-enabled/
    mkdir -p /etc/nginx/sites-available/
    mkdir -p /etc/nginx/sites-enabled/
    EOH
end

template '/etc/nginx/nginx.conf' do
    owner 'root'
    group 'root'
    mode '0644'
    source "nginx/nginx.conf.erb"
end




%w{wcl}.each do |f|

    begin
      
      #Chef::Log.info(" service name  #{service_name} ")
      template "/etc/nginx/sites-available/#{f}" do
        source "#{$service_name}/sites-available/#{f}.erb"
        owner "root"
        group "root"
        mode 0755
        variables({
                :public_ip => public_ip
            })
      end

     bash "Create symlinks" do
        user "root"
        code <<-EOH

        ln -s /etc/nginx/sites-available/#{f} /etc/nginx/sites-enabled/#{f} 

        EOH
     end

   rescue Chef::Exceptions::ResourceNotFound

  
   end

end

if $service_name != "jenkins-master" and $service_name != "jenkins-slave"

template '/etc/nginx/basic_auth' do
    owner 'root'
    group 'root'
    mode '0644'
    source "nginx/basic_auth"
end

end

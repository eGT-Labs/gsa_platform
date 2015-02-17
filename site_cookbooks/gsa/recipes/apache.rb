bash "prep apache files" do
user "root"
code <<-EOH
rm -rf /etc/httpd/sites-available/
rm -rf /etc/httpd/sites-enabled/
mkdir -p /etc/httpd/sites-available/
mkdir -p /etc/httpd/sites-enabled/
EOH
end

template '/etc/httpd/conf/httpd.conf' do
    owner 'root'
    group 'root'
    mode '0644'
    source "apache/conf/httpd.conf"
end


template '/etc/httpd/sites-available/fbopen' do
    owner 'root'
    group 'root'
    mode '0644'
    source "apache/sites-available/fbopen.erb"
end


link "/etc/httpd/sites-enabled/fbopen" do
 to "/etc/httpd/sites-available/fbopen"
end


service "httpd" do
 action :restart
end
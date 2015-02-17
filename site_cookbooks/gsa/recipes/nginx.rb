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


template '/etc/nginx/sites-available' do
    owner 'root'
    group 'root'
    mode '0644'
    source "nginx/sites-available/fbopen.erb"
end
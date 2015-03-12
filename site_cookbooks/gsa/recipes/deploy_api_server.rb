
$apps_dir=node.gsa.global.apps_dir
$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name


directory "/var/log/#{$git_repo_name}" do
  recursive true
end


file "/var/log/#{$git_repo_name}/api.log" do
  action :create_if_missing
end


template "#{$apps_dir}/#{$git_repo_name}/api/config.js" do
    source "api_server/config.js.erb"
    mode 0755
    owner "root"
    group "root"
end

bash "run api server" do
user "root"
code <<-EOH
	cd #{$apps_dir}/#{$git_repo_name}/api
	npm install
	npm install -g forever
	forever -m5 app.js
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
end


$apps_dir=node.gsa.global.apps_dir
$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name

$api_location="#{$apps_dir}/#{$git_repo_name}/src/api"


directory "/var/log/#{$git_repo_name}" do
  recursive true
end


file "/var/log/#{$git_repo_name}/api.log" do
  action :create_if_missing
end


template "#{$api_location}/config.js" do
    source "api_server/config.js.erb"
    mode 0755
    owner "root"
    group "root"
end

bash "run api server" do
user "root"
code <<-EOH
  cd #{$api_location}
  npm install
  # check process already exists
  if [[ -f run.pid ]];
    then
     if ps -p `cat run.pid` > /dev/null
        then
          kill -15 `cat run.pid`
        fi
        rm -rf run.pid
  fi

  nohup node  app.js > api_run.log 2>&1 &
  echo $! > run.pid
EOH
end

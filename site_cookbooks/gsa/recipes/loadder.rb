

$apps_dir=node.gsa.global.apps_dir
$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name


$fbopen_uri="localhost:9200"

$fbopen_index="fbopen"


bash "reate an index on your Elasticsearch" do
user "root"
code <<-EOH
	cd #{$apps_dir}/#{$git_repo_name}
	curl -XPUT localhost:9200/fbopen --data-binary @elasticsearch/init.json
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
end

bash "load fbo.gov loadder" do
user "root"
code <<-EOH
     cd #{$apps_dir}/#{$git_repo_name}/loaders/fbo.gov
	 sudo npm install
     FBOPEN_ROOT=#{$apps_dir}/#{$git_repo_name} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./fbo-nightly.sh
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
end



bash "load fbo.gov loadder" do
user "root"
code <<-EOH
     cd #{$apps_dir}/#{$git_repo_name}/loaders/fbo.gov
	 sudo npm install
     FBOPEN_ROOT=#{$apps_dir}/#{$git_repo_name} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./fbo-nightly.sh | echo "already have"
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
end


bash "load bids.state.gov loadder" do
user "root"
code <<-EOH
     cd #{$apps_dir}/#{$git_repo_name}/loaders/bids.state.gov
	 sudo npm install
     FBOPEN_ROOT=#{$apps_dir}/#{$git_repo_name} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./bids-nightly.sh | echo "already have"
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
end



bash "load grants.gov loadder" do
user "root"
code <<-EOH
     cd #{$apps_dir}/#{$git_repo_name}/loaders/grants.gov
	 sudo npm install
	 mkdir workfiles nightly-downloads tmp
	 
     FBOPEN_ROOT=#{$apps_dir}/#{$git_repo_name} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./grants-nightly.sh | echo "already have"
EOH
only_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
end


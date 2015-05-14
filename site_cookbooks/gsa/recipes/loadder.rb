

$apps_dir=node.gsa.global.apps_dir
$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name

$repo_path="#{$apps_dir}/#{$git_repo_name}/src"

$loaders_path="#{$apps_dir}/#{$git_repo_name}/src/loaders/"


$fbopen_uri="localhost:9200"

$fbopen_index="fbopen"


execute "Recreate an index on your Elasticsearch" do 
   cwd "#{$repo_path}"
   command "curl -XPUT localhost:9200/fbopen --data-binary @elasticsearch/init.json"
   only_if {::File.exists?("#{$repo_path}") }
end 



execute "load fbo.gov loadder" do 
   cwd "#{$loaders_path}/fbo.gov"
   command <<-EOH
     npm install
     FBOPEN_ROOT=#{$repo_path} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./fbo-nightly.sh | echo "already have"
    EOH
   only_if {::File.exists?("#{$repo_path}") }
end 


execute "load bids.state.gov loadder" do
   cwd "#{$loaders_path}/bids.state.gov"
   command <<-EOH
     npm install
     FBOPEN_ROOT=#{$repo_path} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./bids-nightly.sh | echo "already have"
    EOH
   only_if {::File.exists?("#{$repo_path}") }
end 


execute "load grants.gov loadder" do
   cwd "#{$loaders_path}/grants.gov"
   command <<-EOH
     npm install
     mkdir workfiles nightly-downloads tmp
     FBOPEN_ROOT=#{$repo_path} FBOPEN_URI=#{$fbopen_uri} FBOPEN_INDEX=#{$fbopen_index} ./grants-nightly.sh | echo "already have"
    EOH
   only_if {::File.exists?("#{$repo_path}") }
end 


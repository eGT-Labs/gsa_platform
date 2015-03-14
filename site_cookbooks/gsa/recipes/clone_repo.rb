
$apps_dir=node.gsa.global.apps_dir
$git_repo=node.gsa.global.git_repo
$git_repo_name=node.gsa.global.git_repo_name


e=bash "Clone FBOpenrepo" do
user "root"
code <<-EOH
	 
     mkdir -p #{$apps_dir}
     cd #{$apps_dir}
     git clone https://#{$git_repo}

EOH
not_if {::File.exists?("#{$apps_dir}/#{$git_repo_name}") }
action :nothing
end
e.run_action(:run)



bash "Pull git_repo" do
user "root"
code <<-EOH
	cd #{$apps_dir}/#{$git_repo_name}
	git pull | echo "Already uptodate"
    git submodule update --init --recursive

EOH
end



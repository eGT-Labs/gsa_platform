############################################################
####################### GLOBAL ############################
############################################################
$namespace="gsa"

default["namespace"]=$namespace
default[$namespace]["global"]["apps_dir"] = "/apps"
default[$namespace]["global"]["git_repo"] = "github.com/18F/fbopen.git"
default[$namespace]["global"]["git_repo_name"] = "fbopen"
default[$namespace]["global"]["ports"] = %w{9200 80 8000 3000}



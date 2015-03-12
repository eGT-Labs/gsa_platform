############################################################
####################### GLOBAL ############################
############################################################
$namespace="gsa"

default["namespace"]=$namespace

default[$namespace]["global"]["git_repo"] = "github.com/eGT-Labs/fbopen"

default[$namespace]["global"]["apps_dir"] = "/apps"

default[$namespace]["global"]["git_repo_name"] = "fbopen"
default[$namespace]["global"]["ports"] = %w{9200 80 8000 3000}



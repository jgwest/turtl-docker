#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

set -e

export_inlets_token $1
export_inlets_remote $2

echo 

UPSTREAM="http://turtl-server:8181"

docker run -it -d --restart always --link turtl-server --name turtl-inlets \
	--read-only \
	--cap-drop=all \
	turtl-inlets \
	client \
	--strict-forwarding \
	"--upstream=$UPSTREAM" \
	"--remote=$INLETS_REMOTE" \
	"--token=$INLETS_TOKEN"


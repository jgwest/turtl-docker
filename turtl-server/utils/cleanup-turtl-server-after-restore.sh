#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

set -e

docker start turtl-server >/dev/null 2>&1

# Restore fs permissions in the server data dir
docker exec -u root turtl-server rm -rf /var/www/turtl/server/public/uploads/old

echo "* Cleanup of old restore directories is complete."

#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------


# Set the tarsnap key to $1 or to the value from env var file ------------

export_tarsnap_key "$1"


# Set data dir to $2 or env var file ------------

export_turtl_server_data_dir $2


cd ../../tarsnap

./backup-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$SERVER_DATA_DIR" "turtl-server"


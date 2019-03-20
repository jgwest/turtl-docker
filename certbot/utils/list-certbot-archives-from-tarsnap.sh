#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------


# Set the tarsnap key to $1 or to value from env var file ------------

export_tarsnap_key "$1"


cd ../../tarsnap

./list-tarsnap-archives.sh  "$TARSNAP_KEY_FILE" "certbot"



#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 


# Set the tarsnap key to $1 or to the value from env var file ------------

export_tarsnap_key "$1"

# -------


SETTINGS_TEMP_DIR=`./create-temp-settings-backup-dir.sh`
if [ $? -ne 0 ]; then
	echo "Error: Unable to create temp settings directory." 
	exit 1
fi


cd ../../tarsnap

./backup-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$SETTINGS_TEMP_DIR" "turtl-settings"

rm -rf "$SETTINGS_TEMP_DIR"



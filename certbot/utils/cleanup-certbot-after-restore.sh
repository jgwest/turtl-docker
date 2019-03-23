#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

set -e


export TARSNAP_ROOT=/root/tarsnap
export CONTAINER_NAME=turtl-certbot

# Set lets encrypt dir to $1 or env var file ------------

export_letsencrypt_dir "$1"

# Delete the "old/" directory under /etc/letsencrypt
docker run --name turtl-certbot \
        --rm \
        -v "$LE_DIR":/etc/letsencrypt \
        turtl-certbox \
	rm -rf /etc/letsencrypt/old

echo "* Cleanup of old restore directories is complete."

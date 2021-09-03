#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. dev-scripts/trtl-includes.sh
include_trtl_env_vars settings/trtl-env-var.sh 

# -------

set -e

# Set the tarsnap key to $1 or to the value from env var file ------------

export_tarsnap_key $1

# Set lets encrypt dir to $2 or env var file ------------

export_letsencrypt_dir $2

# --------------------------------------------

if [ "$( is_certbot_enabled )" == "true" ]; then

    echo
    echo "* Backing up certbot files"
    echo
    cd $SCRIPT_LOCT/certbot-new/utils
    ./backup-certbot-to-tarsnap.sh "$TARSNAP_KEY_FILE" "$LE_DIR"
    sleep 10s

fi

echo
echo "* Backing up postgres files"
echo
cd $SCRIPT_LOCT/postgres/utils
./backup-postgres-to-tarsnap.sh "$TARSNAP_KEY_FILE"
sleep 10s

echo
echo "* Backing up turtl-server files"
echo
cd $SCRIPT_LOCT/turtl-server/utils
./backup-turtl-server-to-tarsnap.sh "$TARSNAP_KEY_FILE"
sleep 10s

echo
echo "* Backing up settings files"
echo
cd $SCRIPT_LOCT/dev-scripts/settings-backup
./backup-settings-to-tarsnap.sh
sleep 10s
echo

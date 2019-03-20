#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

export CERTBOT_ARCHIVE_NAME=$1
if [ -z "$CERTBOT_ARCHIVE_NAME" ]; then
	echo "Error: Tarsnap archive to restore is not specified as first parameter".
	exit
fi

# Set the tarsnap key to $2 or to value from env var file ------------

export_tarsnap_key "$2"

# Set lets encrypt dir to $3 or env var file ------------

export_letsencrypt_dir "$3"


docker stop turtl-nginx >/dev/null 2>&1

cd ../../tarsnap

./restore-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$LE_DIR" "$CERTBOT_ARCHIVE_NAME"

echo "* Requesting root in order to change the letsencrypt dir permissions:"
sudo chown -R www-data:www-data "$LE_DIR"

# We do this with sudo chown, rather than docker run below, as this allows us 
# to bind mount the letsencrypt dir as read-only in nginx container

# Restore fs permissions in the lets encrypt dir
#docker run --name turtl-certbot \
#        --rm \
#        -v "$LE_DIR":/etc/letsencrypt \
#        turtl-certbox \
#	chown -R www-data:www-data /etc/letsencrypt


docker start turtl-nginx >/dev/null 2>&1

echo
echo "* Your old existing data files have been moved to '(lets encrypt root)/old'."
echo "  Once you have confirmed that the restore operation is successful, you can delete"
echo "  the 'old' directory by calling the 'cleanup-certbot-after-restore.sh' script."
echo 
echo "* The restored files will be visible at $LE_DIR"
echo




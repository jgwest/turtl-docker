
# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

export SERVER_ARCHIVE_NAME=$1
if [ -z "$SERVER_ARCHIVE_NAME" ]; then
	echo "Error: Tarsnap archive to restore is not specified as first parameter".
	exit
fi

# Set the tarsnap key to $2 or to the value from env var file ------------

export_tarsnap_key "$2"

# Set data dir to $3 or env var file ------------

export_turtl_server_data_dir $3



cd ../../tarsnap

./restore-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$SERVER_DATA_DIR" "$SERVER_ARCHIVE_NAME"

docker start turtl-server >/dev/null 2>&1

# Restore fs permissions in the server data dir
docker exec -u root turtl-server chown -R turtl-server-user:turtl-server-user /var/www/turtl/server/public/uploads

docker restart turtl-server >/dev/null 2>&1

echo
echo "* Your existing data files have been moved to '$SERVER_DATA_DIR/old'."
echo "  Once you have confirmed that the restore operation is successful, you can delete"
echo "  the 'old' directory by calling the 'cleanup-turtl-server-after-restore.sh' script."
echo 





exit 0



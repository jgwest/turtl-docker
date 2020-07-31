#!/bin/bash

# Move to the directory of the script ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. dev-scripts/trtl-includes.sh
include_trtl_env_vars settings/trtl-env-var.sh 

# -------

# First parameter can be target directory of archive
TARGET_DIR=$1
if [ -n "$TARGET_DIR" ]; then 
	# If param is specified, then convert to absolute and use it
	TARGET_DIR=`cd $1; pwd`
else
	# Otherwise use curr dir as default
	TARGET_DIR=`pwd`
fi

ARCHIVE_NAME=turtl-backup-`date +%F_%H:%M:%S`.tar.gz
TARGET_ARCHIVE=$TARGET_DIR/$ARCHIVE_NAME


export_turtl_server_data_dir $2
# SERVER_DATA_DIR

export_letsencrypt_dir $3
# LE_DIR


export TURTL_TMP=`mktemp -d`

echo
echo "* Backing up $SERVER_DATA_DIR"
cd $SERVER_DATA_DIR
echo $SERVER_DATA_DIR > $SERVER_DATA_DIR/turtl-server.backup
sudo tar czvf $TURTL_TMP/turtl-server-data-dir.tar.gz *
if [[ $? -ne 0 ]] ; then 
	rm -f $SERVER_DATA_DIR/turtl-server.backup
	rm -rf $TURTL_TMP;
	exit 1;  
fi
rm -f $SERVER_DATA_DIR/turtl-server.backup

if [ "$( is_certbot_enabled )" == "true" ]; then

	echo
	echo "* Backing up $LE_DIR"
	cd $LE_DIR
	sudo bash -c "echo $LE_DIR > $LE_DIR/letsencrypt.backup"
	sudo tar czvf $TURTL_TMP/turtl-letsencrypt-dir.tar.gz *
	if [[ $? -ne 0 ]] ; then 
		sudo rm -f "$LE_DIR/letsencrypt.backup"
		rm -rf "$TURTL_TMP"
		exit 1;  
	fi
	sudo rm -f "$LE_DIR/letsencrypt.backup"

fi

echo
echo "* Backing up Postgres"
cd $SCRIPT_LOCT
cd postgres/utils
PG_TAR_GZ_PATH=$( ./backup-to-gzip.sh )
if [ $? -ne 0 ]; then
	echo Error from Postgres backup, output: $PG_TAR_GZ_PATH
	rm -rf $TURTL_TMP
	exit 1
fi
mv $PG_TAR_GZ_PATH $TURTL_TMP/turtl-postgres.tar.gz


echo
echo "* Backing up settings"

cd $SCRIPT_LOCT/dev-scripts/settings-backup

SETTINGS_TEMP_DIR=`./create-temp-settings-backup-dir.sh`
if [ $? -ne 0 ]; then
        echo "Error: Unable to create temp settings directory." 
	rm -rf $TURTL_TMP
	exit 1;  
fi

cd $SETTINGS_TEMP_DIR

tar czvf $TURTL_TMP/turtl-settings.tar.gz *

cd $TURTL_TMP

echo
echo

tar czvf $TARGET_ARCHIVE *

echo
echo "* Backups complete."

rm -rf $TURTL_TMP
rm -f $PG_TAR_GZ_PATH

echo `basename $TARGET_ARCHIVE`
echo
echo "To extract the archive (required due to colons in the filename), use: tar xzv --force-local f $TARGET_ARCHIVE"
echo 



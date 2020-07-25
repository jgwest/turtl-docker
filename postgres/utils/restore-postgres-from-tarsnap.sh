#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

export POSTGRES_ARCHIVE_NAME=$1
if [ -z "$POSTGRES_ARCHIVE_NAME" ]; then
	echo "Error: Tarsnap archive to restore is not specified as first parameter".
	exit
fi

# Set the tarsnap key to $2 or to the value from env var file ------------

export_tarsnap_key "$2"


docker stop turtl-server >/dev/null 2>&1

docker start turtl-postgres >/dev/null 2>&1

TMP_EXPORT_DIR=`mktemp -d`
if [ $? -ne 0 ]; then echo "Error: Unable to create export dir: $TMP_EXPORT_DIR";  exit 1;  fi


cd ../../tarsnap

./restore-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$TMP_EXPORT_DIR" "$POSTGRES_ARCHIVE_NAME"
if [ $? -ne 0 ]; then echo "Error: Unable to restore from tarsnap.";  exit 1;  fi

TMP_EXPORT_TAR=`mktemp --suffix=.tar.gz`

cd $TMP_EXPORT_DIR

tar cvzf $TMP_EXPORT_TAR * 
if [ $? -ne 0 ]; then echo "Error: Unable to tar the export dir.";  exit 1;  fi
 

docker cp $TMP_EXPORT_TAR turtl-postgres:/tmp/postgres-restore.tar.gz
RC=$?
rm -r "$TMP_EXPORT_DIR"
rm "$TMP_EXPORT_TAR"
if [ $RC -ne 0 ]; then echo "Error: Unable to copy the tar.";  exit 1;  fi



docker exec -u root turtl-postgres  /var/lib/postgresql/tarsnap/restore-from-tarsnap.sh  /tmp/postgres-restore.tar.gz
if [ $? -ne 0 ]; then echo "Error: Unable restore from backup";  exit 1;  fi

echo "* Waiting 20 seconds after restore"
sleep 20s

docker start turtl-server >/dev/null 2>&1



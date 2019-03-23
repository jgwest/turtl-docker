#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

set -e

export CONTAINER_NAME=turtl-postgres
export TARSNAP_ROOT=/var/lib/postgresql/tarsnap

# First parameter must be the archive to restore


ARCHIVE_TO_RESTORE=$1
if [ -z "$ARCHIVE_TO_RESTORE" ]; then
	echo "ERROR: Archive to restore is not specified."
	exit
fi


ARCHIVE_PATH_IN_CONTAINER="/tmp/`basename $ARCHIVE_TO_RESTORE`"

echo \* Stopping turtl-server
docker stop turtl-server


cd $SCRIPT_LOCT

docker cp $ARCHIVE_TO_RESTORE $CONTAINER_NAME:$ARCHIVE_PATH_IN_CONTAINER

set +e

docker exec -u root $CONTAINER_NAME chown -R www-data:www-data $ARCHIVE_PATH_IN_CONTAINER
if [[ $? -ne 0 ]] ; then
        exit 1
fi

docker exec $CONTAINER_NAME $TARSNAP_ROOT/restore-from-gzip.sh $ARCHIVE_PATH_IN_CONTAINER

docker exec -u root $CONTAINER_NAME rm -f $ARCHIVE_PATH_IN_CONTAINER

echo "* Waiting 30 seconds after restore"
sleep 30s

echo "* Restarting Postgres"
docker restart $CONTAINER_NAME

echo "* Waiting after Postgres restart"

sleep 15s

echo \* Starting turtl-server
docker start turtl-server





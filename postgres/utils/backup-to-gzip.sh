#!/bin/bash

# Move to the directory of the script ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

export TARSNAP_ROOT=/var/lib/postgresql/tarsnap
export CONTAINER_NAME=turtl-postgres


# 1) Backup to a temporary directory inside the container
TAR_GZ_PATH=$( docker exec -u www-data $CONTAINER_NAME $TARSNAP_ROOT/backup-to-gzip.sh )
if [ $? -ne 0 ]; then
	echo Error occured in backup-to-gzip.sh. Output: $TAR_GZ_PATH
	exit 1
fi


export TMP_TAR_GZ=`mktemp --suffix=.tar.gz`

# 2) Use docker cp to copy it out
docker cp $CONTAINER_NAME:$TAR_GZ_PATH $TMP_TAR_GZ
if [ $? -ne 0 ]; then
	echo "Unable to docker cp from container"
	rm -f $TMP_TAR_GZ
	docker exec -u root $CONTAINER_NAME rm -f /tmp/*.tar.gz
	exit 1
fi

# 3) Delete it from the container
docker exec -u root $CONTAINER_NAME rm -f $TMP_TAR_GZ


# 4) Test that it exists and has non-zero file size

if [ ! -f $TMP_TAR_GZ ]; then
	echo "Unable to locate backup file at '$TMP_TAR_GZ'."
	exit 1
fi

TMP_TAR_GZ_SIZE="$(wc -c <"$TMP_TAR_GZ")"

if [ "$TMP_TAR_GZ_SIZE" -eq "0" ]; then
	echo "Temp tar gz file is empty"
	rm -f $TMP_TAR_GZ
	exit 1
fi

# 5) Output the part of the temporary zip, for use by the calling script
echo $TMP_TAR_GZ



#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh

# -------

export_tarsnap_key "$1"
# TARSNAP_KEY_FILE

# -------


export TARSNAP_ROOT=/var/lib/postgresql/tarsnap
export CONTAINER_NAME=turtl-postgres


docker start $CONTAINER_NAME >/dev/null 2>&1


# 1) Backup to a temporary directory inside the container

TAR_PATH=$( docker exec -u www-data $CONTAINER_NAME /var/lib/postgresql/tarsnap/pg-dump-to-temp-file.sh )
if [ $? -ne 0 ]; then
        echo Error occured in backup. Output: $TAR_PATH
        exit 1
fi


export LOCAL_TMP_TAR=`mktemp --suffix=.tar.gz`

# 2) Use docker cp to copy it out
docker cp $CONTAINER_NAME:$TAR_PATH $LOCAL_TMP_TAR

if [ $? -ne 0 ]; then
        echo "Unable to docker cp from container"
        rm -f $LOCAL_TMP_TAR
        docker exec -u root $CONTAINER_NAME rm -f $TAR_PATH
        exit 1
fi

# 3) Delete it from the container
docker exec -u root $CONTAINER_NAME rm -f $TAR_PATH

docker exec -u root $CONTAINER_NAME rmdir /var/lib/postgresql/data/turtl-temp/*   >/dev/null 2>&1


# 4) Test that it exists and has non-zero file size
if [ ! -f $LOCAL_TMP_TAR ]; then
        echo "Unable to locate backup file at '$TMP_TAR_GZ'."
        exit 1
fi

TMP_TAR_SIZE="$(wc -c <"$LOCAL_TMP_TAR")"
if [ "$TMP_TAR_SIZE" -eq "0" ]; then
        echo "Temp tar file is empty"
        rm -f $LOCAL_TMP_TAR
        exit 1
fi

# 5) Extract the tar file to a temporary location on the host fs using mktemp
EXTRACT_DIR=`mktemp -d`
cd $EXTRACT_DIR
tar xzf $LOCAL_TMP_TAR

# 6) Tarsnap the local files
rm -f $LOCAL_TMP_TAR

cd $SCRIPT_LOCT/../../tarsnap

./backup-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$EXTRACT_DIR" "postgres"
RC=$?

# 7) Cleanup the temporary location
rm -r $EXTRACT_DIR

exit $RC


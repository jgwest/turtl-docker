#!/bin/bash


export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ./pg-container-includes.sh

# -------------------------


create_scoped_temp_dir "pg-dump-dir"
# GENERATED_TMP_DIR

TEMP_DIR=$GENERATED_TMP_DIR


pg_dump --format=directory --file=$TEMP_DIR  --compress=0 -d postgres -U postgres -p 5432
if [[ $? != 0 ]]; then
	echo "Error: Unable to dump postgres contents to file."
	exit 1
fi


create_scoped_temp_dir "pg-dump-archive"
# GENERATED_TMP_DIR
TEMP_FILE="$GENERATED_TMP_DIR/pg-dump-archive.tar.gz"

set -e

# TEMP_FILE=`mktemp --suffix=.tar.gz`

cd $TEMP_DIR
tar czf $TEMP_FILE *

rm -rf $TEMP_DIR

echo $TEMP_FILE
exit 0

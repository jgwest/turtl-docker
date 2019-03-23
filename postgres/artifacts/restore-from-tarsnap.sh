#!/bin/bash

export SCRIPT_ROOT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_ROOT

. ./pg-container-includes.sh

# ---------------------

export TAR_TO_EXTRACT=$1
if [ -z "$TAR_TO_EXTRACT" ]; then
	echo "Error: Tar to extract was not specified."
	exit 1
fi

if [ ! -f $TAR_TO_EXTRACT ]; then
	echo "Error: Tar to extract was not found: $TAR_TO_EXTRACT"
	exit 1
fi


create_scoped_temp_dir "restore-from-tarsnap"
# GENERATED_TMP_DIR

TEMP_DIR=$GENERATED_TMP_DIR
if [[ $? != 0 ]]; then
	echo "Error: Unable to create temp file. Result: $TEMP_FILE"
	rm -f "$TAR_TO_EXTRACT"
	exit 1
fi

cd "$TEMP_DIR"
tar xzvf "$TAR_TO_EXTRACT"




# --create
pg_restore --clean --if-exists --format=directory --no-password --verbose -d postgres -U postgres -p 5432 $TEMP_DIR
if [ $? -ne 0 ]; then 
	rm -f "$TAR_TO_EXTRACT"
	rm -rf "$TEMP_DIR"
	echo "Error: Unable to restore."
	exit 1
fi

rm -rf "$TEMP_DIR"
rm -f "$TAR_TO_EXTRACT"


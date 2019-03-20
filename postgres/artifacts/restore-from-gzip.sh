#!/bin/bash

export SCRIPT_ROOT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_ROOT

. ./pg-container-includes.sh

# -------------------------

# Parameter is the path of the archive to restore

export VAL=$1
export VAL_BASE=`basename "$VAL"`

# If the file name indicates that it contains the 3 backup archives, then untar it first
if [[ $VAL_BASE == turtl-backup-20*.tar.gz ]]; then
	create_scoped_temp_dir "restore-from-gzip"
	# GENERATED_TMP_DIR

	export EXTRACTED_DIR=$GENERATED_TMP_DIR
	
	cd $EXTRACTED_DIR
	tar xzvf $VAL
	export VAL=$EXTRACTED_DIR/turtl-postgres.tar.gz
	export VAL_BASE=`basename "$VAL"`
fi

# If the file name indicates it is a turtl-postgres backup, then use it
if [[ $VAL_BASE == turtl-postgres.tar.gz ]]; then
	gzip -d -c $VAL | pg_restore --clean --if-exists --format=tar --no-password --verbose -d postgres -U postgres -p 5432	
	echo "* Postgres restore complete"

	# If we created a temporary directory in the previous steps, then erase it
	if [ -n "$EXTRACTED_DIR" ]; then  rm -rf $EXTRACTED_DIR; fi

	exit 0
fi

echo "Error: Unable to locate backup archive from provided parameter."

# If we created a temporary directory in the previous steps, then erase it
if [ -n "$EXTRACTED_DIR" ]; then  rm -rf $EXTRACTED_DIR; fi

exit 1



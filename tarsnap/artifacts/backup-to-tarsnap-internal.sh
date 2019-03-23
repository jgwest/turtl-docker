#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_ROOT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_ROOT

. ./tarsnap-container-env-vars.sh
# ARCHIVE_SUFFIX / KEY_FILE / ARCHIVE_NAME / CACHE_DIR / BACKUP_DIR

if [ ! -f $CACHE_DIR/directory ]; then
	echo "* Acquiring Tarsnap cache."
	tarsnap --fsck --humanize-numbers --cachedir $CACHE_DIR --keyfile $KEY_FILE 
	# >/dev/null 2>&1	
fi



cd $BACKUP_DIR

echo "* Backing up."

tarsnap --humanize-numbers --cachedir $CACHE_DIR --keyfile $KEY_FILE -c --print-stats -v -f $ARCHIVE_NAME \
	--exclude /tarsnap/target/old \
	.
RC=$?

if [ $RC -gt 0 ]; then
	echo "* Error occured on backup. Flushing cache directory and exiting."
	echo
	echo "Current directory contents of '$CACHE_DIR':"
	ls -l $CACHE_DIR
	echo	
	rm -rf $CACHE_DIR/*
	echo "* Directory flushed."
	echo

	echo "After deletion directory contents of '$CACHE_DIR':"
	ls -l $CACHE_DIR
	echo

	exit 1
fi

echo
echo  "* Pruning old archives"

"$SCRIPT_ROOT/tsar.sh"

echo "* Backup complete."

echo


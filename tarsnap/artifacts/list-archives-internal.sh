#!/bin/bash

export SCRIPT_ROOT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_ROOT

. ./tarsnap-container-env-vars.sh
# ARCHIVE_SUFFIX / KEY_FILE / ARCHIVE_NAME / CACHE_DIR / BACKUP_DIR


if [ ! -f $CACHE_DIR/directory ]; then
	echo "* Acquiring Tarsnap cache."
	tarsnap --fsck --humanize-numbers --cachedir $CACHE_DIR --keyfile $KEY_FILE 
	# >/dev/null 2>&1
fi


echo
tarsnap --humanize-numbers --cachedir $CACHE_DIR --keyfile $KEY_FILE --list-archives | grep $ARCHIVE_SUFFIX | sort
RC=$?

if [ $RC -gt 0 ]; then
	echo
	echo "* Error occured on backup. Flushing cache directory and exiting."
	rm -rf "$CACHE_DIR"
	exit 1
fi

echo


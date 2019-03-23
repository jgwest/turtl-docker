#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_ROOT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_ROOT

. ./tarsnap-container-env-vars.sh
# ARCHIVE_SUFFIX / KEY_FILE / ARCHIVE_NAME / CACHE_DIR / BACKUP_DIR

echo "* Acquiring Tarsnap cache."


if [ ! -f $CACHE_DIR/directory ]; then
	echo "* Acquiring Tarsnap cache."
	tarsnap --fsck --humanize-numbers --cachedir $CACHE_DIR --keyfile $KEY_FILE 
	# >/dev/null 2>&1	
fi


# If the $BACKUP_DIR/old directory already exists, then move it to $BACKUP_DIR/old/old
mkdir -p $BACKUP_DIR/old
mv $BACKUP_DIR/old $BACKUP_DIR/old2
mkdir -p $BACKUP_DIR/old
mv $BACKUP_DIR/old2 $BACKUP_DIR/old/old2
mv $BACKUP_DIR/old/old2 $BACKUP_DIR/old/old

mv $BACKUP_DIR/* $BACKUP_DIR/old >/dev/null 2>&1

rmdir $BACKUP_DIR/old/old >/dev/null 2>&1
rmdir $BACKUP_DIR/old >/dev/null 2>&1

cd $BACKUP_DIR

echo "* Restoring backup."

tarsnap --cachedir $CACHE_DIR --keyfile $KEY_FILE -x -v -f $1  
RC=$?
if [ $RC -gt 0 ]; then
	echo "* Error occured on restore. Flushing cache directory and exiting."
	rm -rf "$CACHE_DIR"
	exit 1
fi

echo "* Restore complete."


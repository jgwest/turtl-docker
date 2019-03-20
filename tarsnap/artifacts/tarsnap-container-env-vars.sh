#!/bin/bash


export ARCHIVE_SUFFIX=$1
if [ -z "$ARCHIVE_SUFFIX" ]; then
        echo "Error: Archive suffix not specified as first parameter."
        exit
fi


export KEY_FILE=/tarsnap/key/tarsnap.key

export ARCHIVE_NAME=$ARCHIVE_SUFFIX-`date +%F_%H:%M:%S`

export CACHE_DIR=/tarsnap/cache

export BACKUP_DIR=/tarsnap/target

chown -R root:root /tarsnap/cache >/dev/null 2>&1



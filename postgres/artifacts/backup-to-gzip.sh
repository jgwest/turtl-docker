#!/bin/bash

set -e

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ./pg-container-includes.sh

# -------------------------

create_scoped_temp_dir "gzip-backup"
# GENERATED_TMP_DIR

TMP_TAR_GZ="$GENERATED_TMP_DIR/pg-dump-backup.tar.gz"

pg_dump --format=tar --compress=0 -d postgres -U postgres -p 5432 | gzip > $TMP_TAR_GZ

# Output the path, so that it can be copied out
echo $TMP_TAR_GZ


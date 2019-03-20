#!/bin/bash

# Move to the directory of the script that included this include file
export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT


set -e

cd $SCRIPT_LOCT

./run.sh

cd utils
./backup-certbot-to-tarsnap.sh

cd ..


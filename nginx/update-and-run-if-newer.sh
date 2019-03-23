#!/bin/bash

# Move to the directory containing the script file
export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

set -e

export PULL_RESULT=`docker pull nginx:stable | grep "is up to date for"`

if [ -z "$PULL_RESULT" ]; then
	echo "Newer nginx detected."
	./build.sh
	./run.sh
	echo "Nginx updated on `date`"
	exit 0
else
	echo "Nginx is up to date: $PULL_RESULT"
	exit 0
fi



#!/bin/bash

export TARSNAP_KEY_FILE=$1
if [ -n "$TARSNAP_KEY_FILE" ]; then
	
	export TARSNAP_KEY_FILE="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"

	if [ ! -f "$TARSNAP_KEY_FILE" ]; then
		echo "Unable to locate tarsnap key file at '$TARSNAP_KEY_FILE'."
		exit
	fi

	if [[ `basename $TARSNAP_KEY_FILE` != tarsnap.key ]]; then
		echo "Tarsnap key must be named 'tarsnap.key'."
		exit
	fi

else 
	echo "Error: Tarsnap key file path was not specified as first parameter." 
	exit
fi

export ARCHIVE_SUFFIX=$2
if [ -z "$ARCHIVE_SUFFIX" ]; then
        echo "Error: Archive suffix not specified as third parameter."
        exit
fi

echo "* Using $TARSNAP_KEY_FILE as key path."
echo "* Archive name: $ARCHIVE_SUFFIX"
echo

export TARSNAP_KEY_DIRECTORY=`dirname $TARSNAP_KEY_FILE`



#/bin/bash

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

export TARGET_DIR=$2
if [ -n "$TARGET_DIR" ]; then

	if [ ! -d "$TARGET_DIR" ]; then
		echo "Unable to locate target directory to backup at '$TARGET_DIR'."
		exit
	fi

	export TARGET_DIR="$(cd "$(dirname "$2")"; pwd)/$(basename "$2")"
else 
	echo "Error: The target directory to backup was not specified." 
	exit
fi


export ARCHIVE_SUFFIX=$3
if [ -z "$ARCHIVE_SUFFIX" ]; then

	if [ $TARSNAP_MODE = "backup" ]; then echo "Error: Archive suffix not specified as third parameter."; fi
	if [ $TARSNAP_MODE = "restore" ]; then echo "Error: Archive name not specified as third parameter."; fi

        exit
fi

echo "* Using $TARSNAP_KEY_FILE as key path."

if [ $TARSNAP_MODE = "backup" ]; then echo "* Backing up $TARGET_DIR."; fi
if [ $TARSNAP_MODE = "restore" ]; then echo "* Restoring to $TARGET_DIR."; fi

if [ $TARSNAP_MODE = "backup" ]; then echo "* Archive suffix: $ARCHIVE_SUFFIX"; fi
if [ $TARSNAP_MODE = "restore" ]; then echo "* Archive name: $ARCHIVE_SUFFIX"; fi


echo

export TARSNAP_KEY_DIRECTORY=`dirname $TARSNAP_KEY_FILE`



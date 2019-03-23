#!/bin/bash

TEMP_FILE=`mktemp`

TARGET_ADDR=$1
if [ -z "$TARGET_ADDR" ]; then
	echo "Error: First parameter should be destination email."
	exit 1
fi

SUBJECT=$2
if [ -z "$SUBJECT" ]; then
	echo "Error: Second parameter should be email subject."
	exit 1
fi


echo "To: $TARGET_ADDR" > $TEMP_FILE 
echo "From: $TARGET_ADDR" >> $TEMP_FILE 
echo "Subject: $SUBJECT" >> $TEMP_FILE 
echo >> $TEMP_FILE 

echo $TEMP_FILE




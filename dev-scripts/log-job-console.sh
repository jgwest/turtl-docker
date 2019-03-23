#!/bin/bash


# Move to the directory of the script ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ./trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

export_email_address ""
# EMAIL

# params: (target log directory) (job name) (commands to up+)

if [ -z "$1" ]; then
	echo "Error: A directory (outside the container) to store log files in, was not specified as the first parameter."
	exit 1
fi

if [ -z "$2" ]; then
	echo "Error: A job name was not specified as the second parameter."
	exit 1
fi


TARGET_DIR="$1"/`date +%F`

FILENAME="$2"-`date +%H:%M:%S`.log

DIR_PLUS_FILENAME=$TARGET_DIR/$FILENAME

mkdir -p $TARGET_DIR

# Run the command specified on params 2 and up
${@:3} > $DIR_PLUS_FILENAME 2>&1
RC=$?
if [ $RC -ne 0 ]; then
	EMAIL_FILE=`./create-email-form.sh $EMAIL "Turtl-docker: Job '$2' failed"`
	echo "See logs at $DIR_PLUS_FILENAME" >> $EMAIL_FILE
	../mail/send-mail.sh $EMAIL_FILE $EMAIL
	rm -f $EMAIL_FILE
fi

echo "Job $2 return code was: $RC"
exit $RC


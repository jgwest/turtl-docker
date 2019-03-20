#!/bin/bash


export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

set -e

if [ -z "$TRTL_MAIL_SETTINGS_MSMTPRC_DIR" ]; then
	echo "The directory of the mail file is not specified, so skipping mail send operation."
	exit 0
fi

MSMTPRC_FILE="$TRTL_MAIL_SETTINGS_MSMTPRC_DIR/msmtprc"
if [ ! -f "$MSMTPRC_FILE" ]; then
	echo "Error: The mail file directory does not exist, or does not contain a msmtprc file: $MSMTPRC_FILE"
	exit 1
fi


EMAIL_FILE=$1
if [ -z "$EMAIL_FILE" ]; then 	
	echo "Error: First parameter should be location of email file"
	exit 1
fi

if [ ! -f $EMAIL_FILE ]; then
	echo "Error: Email file at path '$EMAIL_FILE' does not exist"
	exit 1
fi

TARGET_EMAIL=$2
if [ -z "$TARGET_EMAIL" ]; then
	echo "Error: Second parameter should be the target email address (but it should match the address in the email file"
	exit 1
fi

TMP_DIR=`mktemp -d`

cp $EMAIL_FILE $TMP_DIR/email.txt

docker run --name turtl-mail  \
	--rm \
	-it \
	-v "$TMP_DIR":/input \
	-v "$TRTL_MAIL_SETTINGS_MSMTPRC_DIR":/msmtprc-input \
	turtl-mail \
	/send-mail-container.sh $TARGET_EMAIL


rm -rf $TMP_DIR



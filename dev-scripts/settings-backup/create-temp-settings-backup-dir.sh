
#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

SETTINGS_TEMP_DIR=`mktemp -d`
if [ $? -ne 0 ]; then
	exit 1
fi


# TRTL_TARSNAP_KEY ---------

if [ -n "$TRTL_TARSNAP_KEY" ]; then

	if [ -f "$TRTL_TARSNAP_KEY" ]; then
		cp "$TRTL_TARSNAP_KEY" "$SETTINGS_TEMP_DIR"
	fi

fi

# TRTL_MAIL_SETTINGS_MSMTPRC_DIR --------

if [ -n "$TRTL_MAIL_SETTINGS_MSMTPRC_DIR" ]; then

	if [ -f "$TRTL_MAIL_SETTINGS_MSMTPRC_DIR/msmtprc" ]; then
		cp "$TRTL_MAIL_SETTINGS_MSMTPRC_DIR/msmtprc" "$SETTINGS_TEMP_DIR"
	fi

fi


# trtl-env-var.sh from $TEV_SCRIPT_LOCT

if [ -n "$TEV_SCRIPT_LOCT" ]; then

	if [ -f "$TEV_SCRIPT_LOCT/trtl-env-var.sh" ]; then
		cp "$TEV_SCRIPT_LOCT/trtl-env-var.sh" "$SETTINGS_TEMP_DIR"
	fi

fi

echo $SETTINGS_TEMP_DIR

exit 0


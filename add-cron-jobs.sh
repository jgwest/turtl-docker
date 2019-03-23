#!/bin/bash


export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. dev-scripts/trtl-includes.sh
include_trtl_env_vars settings/trtl-env-var.sh

# -------------------------

TMP_NEW_CRON=`mktemp`
if [[ $? != 0 ]]; then	
	echo "Error: Unable to create temporary file."
	exit
fi

# Copy current cron to file
crontab -l > "$TMP_NEW_CRON" 2>&1

# Remove 'no crontab for' if it is present, but otherwise leave the crontab intact
# Also remove any existing turtl job entries.
CRONTAB_LIST_OUTPUT=`cat "$TMP_NEW_CRON" | grep -v "no crontab for" | grep -v "#turtl-job"`

# Put the contents back into the temp file
echo "$CRONTAB_LIST_OUTPUT" > "$TMP_NEW_CRON"

# crontab -l | grep -v "#turtl-job" > "$TMP_NEW_CRON"
#if [[ $? != 0 ]]; then
#	rm -f "$TMP_NEW_CRON"
#	echo "Error: Command failed, aborting."
#	echo "You may need to create a new crontab file with 'crontab -e' before running this command."
#	exit
#fi

# echo "12 4 */1 * * \"$SCRIPT_LOCT/dev-scripts/job-script.sh\" 		#turtl-job" >> "$TMP_NEW_CRON"
#echo "\"$REPO_ROOT/dev-scripts/log-job-console.sh\" \"$REPO_ROOT/logs\" \"job\" \"$REPO_ROOT/dev-scripts/job-script.sh\" 		#turtl-job" >> "$TMP_NEW_CRON"


echo "12 4 * * *  \"$SCRIPT_LOCT/dev-scripts/log-job-console.sh\" \"$SCRIPT_LOCT/logs\" \"job\" \"$SCRIPT_LOCT/dev-scripts/job-script.sh\" 		#turtl-job" >> "$TMP_NEW_CRON"



cat "$TMP_NEW_CRON" | crontab -

rm -f "$TMP_NEW_CRON"
echo
echo "* User crontab is now:"
echo
crontab -l
echo

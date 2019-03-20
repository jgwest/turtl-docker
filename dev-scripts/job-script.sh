#/bin/bash

SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ./trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh

# -------------------------

# Get day of year and convert to integer, for use by mod operator.
DAY_OF_YEAR=`date '+%j'`
DAY_OF_YEAR=$(expr $DAY_OF_YEAR + 0)

FILE_DOW=$(date +%w)
FILE_DOM=$(date +%d)

REPO_ROOT="$SCRIPT_LOCT/.."

# renew and backup certbox:
# - Run the renew on every Monday, and every 1st of the month (in both cases, we do this for tsar)
# - Otherwise, run every 6 days.
if [ "$FILE_DOW" -eq "1" ] || [ "$FILE_DOM" -eq "01" ] || [ $(( $DAY_OF_YEAR % 6 )) -eq 0 ]; then
	"$REPO_ROOT/dev-scripts/log-job-console.sh" "$REPO_ROOT/logs" "certbot" "$REPO_ROOT/certbot/job-renew-and-backup.sh" 
	sleep 10s
fi



# update nginx ( no backup ) (/3)
if [ $(( $DAY_OF_YEAR % 3 )) -eq 0 ]; then
	"$REPO_ROOT/dev-scripts/log-job-console.sh" "$REPO_ROOT/logs" "nginx" "$REPO_ROOT/nginx/update-and-run-if-newer.sh"
	sleep 10s
fi

# backup postgres
"$REPO_ROOT/dev-scripts/log-job-console.sh" "$REPO_ROOT/logs" "postgres" "$REPO_ROOT/postgres/utils/backup-postgres-to-tarsnap.sh"
sleep 10s

# backup turtl server
"$REPO_ROOT/dev-scripts/log-job-console.sh" "$REPO_ROOT/logs" "turtl-server" "$REPO_ROOT/turtl-server/utils/backup-turtl-server-to-tarsnap.sh"
sleep 10s

# backup settings
"$REPO_ROOT/dev-scripts/log-job-console.sh" "$REPO_ROOT/logs" "settings-backup" "$REPO_ROOT/dev-scripts/settings-backup/backup-settings-to-tarsnap.sh"
sleep 10s




#!/bin/bash



# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

set -e

# Set data dir to $1 or env var file ------------

export_postgres_data_dir $1

# Postgres password is $2 or env var ----------


# If param 2 is specified, then convert to absolute and use it

export_postgres_password $2

# ---------------------------

CONTAINER_NAME=turtl-postgres

# If there is a test container name specified, then use that instead.
if [ -n "$TEST_CONTAINER_NAME" ]; then
	CONTAINER_NAME=$TEST_CONTAINER_NAME
fi

set +e

docker stop --time 30 $CONTAINER_NAME >/dev/null 2>&1

docker rm -f $CONTAINER_NAME >/dev/null 2>&1

set -e

docker run \
	--name $CONTAINER_NAME \
	-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
	-d \
	--user www-data \
	--restart always \
	-v "$POSTGRES_DATA_DIR":/var/lib/postgresql/data \
	turtl-postgres

# Unable to add --read-only due to "could not create lock file "/var/run/postgresql/.s.PGSQL.5432.lock": Read-only file system"

while true; do

	export TURTL_POSTGRES_READY=`docker logs turtl-postgres 2>&1  | grep "accept connections"`

	if [ -z "$TURTL_POSTGRES_READY" ]; then
		echo "* Waiting for Postgres to start."
		sleep 1s
	else
		echo "* Postgres has started."
		break
	fi
	
done

echo "* Waiting 15 more seconds after 'accept connections' to allow for server initialization."
sleep 15


#        --cap-drop=all --cap-add=chown --cap-add=kill --cap-add=dac_override \


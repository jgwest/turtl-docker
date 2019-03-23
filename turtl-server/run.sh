#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

set -e


# Set data dir to $1 or env var file ------------

export_turtl_server_data_dir $1

# ------------------

set +e

docker stop turtl-server >/dev/null 2>&1

docker rm -f turtl-server >/dev/null 2>&1

set -e

docker run \
	--name turtl-server \
	--restart always \
	--link turtl-postgres:postgres \
	--cap-drop=all --cap-add=chown --cap-add=kill --cap-add=dac_override \
	--read-only \
	-d \
	-v "$SERVER_DATA_DIR":/var/www/turtl/server/public/uploads \
	turtl-server



rc=$?; if [[ $rc != 0 ]]; then 
	echo \* Docker run failed.
	exit $rc; 
fi

docker exec -u root turtl-server chown -R turtl-server-user:turtl-server-user /var/www/turtl/server/public/uploads
rc=$?; if [[ $rc != 0 ]]; then 
	echo \* Updating the permissions failed.
	exit $rc; 
fi


while true; do

	export TURTL_SERVER_READY=`docker logs turtl-server 2>&1  | grep "Listening for turtls on port"`

	if [ -z "$TURTL_SERVER_READY" ]; then
		echo \* Waiting for Turtl server to start.
		sleep 1s
	else
		echo \* Turtl server has started.
		break
	fi
	
done



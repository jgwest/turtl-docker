#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

# Set lets encrypt dir to $1 or env var file ------------

export_letsencrypt_dir "$1"
# LE_DIR

export_domain_name $2
# DOMAIN_ONE


export TMP_DIR="$SCRIPT_LOCT/../data/nginx-tmp"

docker stop turtl-nginx  >/dev/null 2>&1

docker rm -f turtl-nginx >/dev/null 2>&1

set -e

docker run --link turtl-server --name turtl-nginx -d \
	-p 443:8443 \
	-e "TRTL_DOMAIN_NAME=$DOMAIN_ONE" \
	--restart always \
	--read-only \
	--cap-drop=all --cap-add=chown --cap-add=kill --cap-add=dac_override \
	-v "$LE_DIR":/etc/letsencrypt:ro \
	-v "$TMP_DIR/conf.d":/etc/nginx/conf.d \
	-v "$TMP_DIR/cache":/var/cache/nginx \
	-v "$TMP_DIR/var-run":/var/run \
	turtl-nginx 



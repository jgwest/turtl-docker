#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

set -e

if [ ! -f /etc/letsencrypt/live/$TRTL_DOMAIN_NAME/fullchain.pem ]; then
       # The certificate is not present, so instruct the container to remove the ssl references from nginx config
       export TRTL_DOMAIN_NAME=noletsencrypt
fi

rm -rf /var/run/*  >/dev/null 2>&1

rm -rf /var/cache/nginx/*  >/dev/null 2>&1

touch /var/run/nginx.pid


./substitute-values-in-config.sh $TRTL_DOMAIN_NAME

cd /turtl-nginx

nginx -g "daemon off;"


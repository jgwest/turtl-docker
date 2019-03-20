#!/bin/bash

export EMAIL=$1
export DOMAIN_ONE=$2
export DOMAIN_TWO=$3

if [ ! -f /etc/letsencrypt/live/$DOMAIN_ONE/fullchain.pem ]; then
	echo \* Certificates not found, creating new Lets Encrypt certificates
	/root/artifacts/create.sh $* 
else 
	echo \* Certificate found, attempting to renew.
	/root/artifacts/renew.sh $*
fi

chown -R www-data:www-data /etc/letsencrypt


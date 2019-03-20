#!/bin/bash

set -e

if [ -n "$1" ]; then
	export DOMAIN_NAME=$1
else
	export DOMAIN_NAME=noletsencrypt
	#echo "Domain name was not specified."
	#exit 1
fi


# mktemp


# /etc/nginx/conf.d-default/default.conf


if [ "$DOMAIN_NAME" == "noletsencrypt" ]; then
	# This allows the nginx container to run even if letsencrypt certs are not linked.
	echo "* Letsencrypt directory not found, so removing SSL values from nginx' site.conf"
	cat /etc/nginx/conf.d-default/default.conf | grep -v "ssl_cert" > /etc/nginx/conf.d/default.conf
else
	cp /etc/nginx/conf.d-default/default.conf /etc/nginx/conf.d/default.conf
	echo "* Substituting domain name into nginx' site.conf."
        sed -i 's/nopkw3qqv/'$DOMAIN_NAME'/g' /etc/nginx/conf.d/default.conf
fi




#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 


# Set lets encrypt dir to $1 or env var file ------------

export_letsencrypt_dir "$1"

export_email_address "$2"

export_domain_name "$3"

export_domain_name_www $4


# Test if the public IP of this machine resolves to the provided domain name ---

MY_EXTERNAL_IP=`curl -s ifconfig.me`
if [ $? -ne 0 ]; then
	echo "* Unable to resolve public IP address of this machine: $MY_EXTERNAL_IP"
	exit 1
fi

NSLOOKUP_RESULT=`nslookup $DOMAIN_TWO`
if [ $? -ne 0 ]; then
	echo "* Unable to nslookup $DOMAIN_TWO - Output: $NSLOOKUP_RESULT"
	exit 1
fi

if [[ $NSLOOKUP_RESULT == *$MY_EXTERNAL_IP* ]]; then
	echo "This machine successfully DNS resolved to the specified domain name: $DOMAIN_TWO"		
else
	echo
	echo "Warning: This machine does not appear to DNS resolve to the specified domain name: $DOMAIN_TWO."
	echo "Let Encrypt's certbot will not be used to acquire a certificate for this machine."
	echo

	exit 0
fi


# ----

echo 

docker stop turtl-nginx >/dev/null 2>&1

docker rm -f turtl-certbot >/dev/null 2>&1

set -e

docker run --name turtl-certbot  \
	--rm \
	-p 80:80  \
	--cap-drop=all --cap-add=chown --cap-add=kill --cap-add=dac_override --cap-add=net_bind_service \
	-v "$LE_DIR":/etc/letsencrypt \
	turtl-certbox \
	/root/artifacts/do.sh "$EMAIL" "$DOMAIN_ONE" "$DOMAIN_TWO"

#chown -R www-data:www-data $LE_DIR

set +e

docker start turtl-nginx >/dev/null 2>&1

exit 0

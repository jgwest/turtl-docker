#!/bin/bash

if [ -n "$1" ]; then
	export POSTGRES_PASSWORD=$1
else
	echo "Postgres password parameter was not specified."
	exit 1
fi

if [ -n "$2" ]; then
	export DOMAIN_NAME_WWW=$2
else
	echo "WWW domain name was not specified."
	exit 1
fi


if [ -n "$3" ]; then
	export SECURE_HASH_SALT="$3"
else
	echo "Secure hash salt is not specified."
	exit 1
fi


echo "* Substituting postgres password into config.yaml."

sed -i 's/eblfkp7385mfph8cy1hcmfaieahd8qkc/'$POSTGRES_PASSWORD'/g' /app/config/config.yaml

echo "* Substituting domain name into config.yaml."

sed -i 's/xqxohx6rsa/'$DOMAIN_NAME_WWW'/g' /app/config/config.yaml

echo "* Substituting secure hash salt into config.yaml."

sed -i 's/TmMhqRNG9p/'"$SECURE_HASH_SALT"'/g' /app/config/config.yaml


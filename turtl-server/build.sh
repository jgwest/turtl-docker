#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh 

# -------

set -e

# Postgres password is $1 or env var ----------

export_postgres_password $1
# POSTGRES_PASSWORD

export_domain_name_www $2
# DOMAIN_TWO

export_secure_hash_salt $3
# SECURE_HASH_SALT

# ---------------------------

docker build -t turtl-server \
	--build-arg TRTL_POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
	--build-arg TRTL_DOMAIN_NAME_WWW="$DOMAIN_TWO" \
	--build-arg TRTL_SECURE_HASH_SALT="$SECURE_HASH_SALT" \
	.



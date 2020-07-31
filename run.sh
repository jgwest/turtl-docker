#!/bin/bash

# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. dev-scripts/trtl-includes.sh
include_trtl_env_vars settings/trtl-env-var.sh 

export_postgres_data_dir $1
# POSTGRES_DATA_DIR

export_turtl_server_data_dir $2
# SERVER_DATA_DIR

export_letsencrypt_dir $3
# LE_DIR

#export TARSNAP_EXPECTED_DIR=$LOCT/settings

#echo
#if [ ! -f $TARSNAP_EXPECTED_DIR/tarsnap.key ]; then
#	echo "NOTE: A 'tarsnap.key' file could not be found at $TARSNAP_EXPECTED_DIR/tarsnap.key."
#	echo "This is an optional file, but there will be no automatic backup of postgres or turtl data without this key file."
#	export TARSNAP_EXPECTED_DIR=
#	exit
#else
#	echo "A 'tarsnap.key' file was found in the settings/ directory and will be used for postgres/turtl backup."
#fi

set -e

cd $SCRIPT_LOCT


if [ "$( is_certbot_enabled )" == "true" ]; then

    echo 
    echo "* Acquiring/renewing SSL/TLS certificate from Let's Encrypt."
    cd certbot
    ./run.sh
    cd ..

fi

echo 
echo "* Starting Postgres"
cd postgres
./run.sh $POSTGRES_DATA_DIR
cd ..

echo 
echo "* Starting Turtl server"
cd turtl-server
./run.sh $SERVER_DATA_DIR
cd ..

if [ "$( is_nginx_enabled )" == "true" ]; then

    echo
    echo "* Starting nginx"
    cd nginx
    ./run.sh $LE_DIR
    cd ..

fi

if [ "$( is_inlets_enabled )" == "true" ]; then

    echo
    echo "* Starting inlets client"
    cd inlets
    ./run.sh
    cd ..
    
fi

#!/bin/bash


include_trtl_env_vars () {

	# Include the env var script if it exists
	if [ -f $1 ]; then
		. $1
	fi
}


# This function exits with 0 if tarsnap key is not specified as an env var/param 
# (this is a non-error condition as tarsnap key is optional)
export_tarsnap_key () {

	export TARSNAP_KEY_FILE=$1
	if [ -n "$TARSNAP_KEY_FILE" ]; then
		# If param is specified, then convert to absolute and use it
		export TARSNAP_KEY_FILE="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
	fi

	if [ -z "$TARSNAP_KEY_FILE" ]; then
		export TARSNAP_KEY_FILE=$TRTL_TARSNAP_KEY
	fi

	if [ -n "$TARSNAP_KEY_FILE" ]; then
		assert_no_spaces "$TARSNAP_KEY_FILE"
	fi


	if [ -z "$TARSNAP_KEY_FILE" ]; then
		echo "Tarsnap backup key file is not specified, exiting."
		exit 0
	else

		if [ ! -f $TARSNAP_KEY_FILE ]; then
			echo "Unable to locate tarsnap key file at '$TARSNAP_KEY_FILE'."
			exit 1
		else
			echo "Using $TARSNAP_KEY_FILE as tarsnap key file."
		fi
	fi

}


export_letsencrypt_dir () {

	export LE_DIR=$1
	if [ -n "$LE_DIR" ]; then 
		# If param is specified, then convert to absolute and use it
		export LE_DIR=`cd $1; pwd`
	fi

	if [ -z "$LE_DIR" ]; then
		export LE_DIR=$TRTL_LETS_ENCRYPT_DIR
	fi

	if [ -n "$LE_DIR" ]; then
		assert_no_spaces "$LE_DIR"
	fi

	if [ -z "$LE_DIR" ]; then
		echo "No letsencrypt directory specified. Directory argument required."
		exit 1
	else
		echo "Using $LE_DIR as letsencrypt directory."
	fi

}

export_postgres_data_dir () {

	export POSTGRES_DATA_DIR=$1
	if [ -n "$POSTGRES_DATA_DIR" ]; then 
		convert_to_absolute $POSTGRES_DATA_DIR
		export DATA_DIR=$ABSPATH
		unset ABSPATH
	fi

	if [ -z "$POSTGRES_DATA_DIR" ]; then 	
		if [ -n "$TRTL_DATA_DIR" ]; then 
			export POSTGRES_DATA_DIR=$TRTL_DATA_DIR/postgres
		fi		

	fi

	if [ -n "$POSTGRES_DATA_DIR" ]; then
		assert_no_spaces "$POSTGRES_DATA_DIR"
	fi

	if [ -z "$POSTGRES_DATA_DIR" ]; then
		echo "No data directory specified. Directory argument required."
		exit 1
	else
		echo "Using $POSTGRES_DATA_DIR as data directory."
	fi

}

export_turtl_server_data_dir () {

	export SERVER_DATA_DIR=$1

	if [ -n "$SERVER_DATA_DIR" ]; then 
		# If param 1 is specified, then convert to absolute and use it
		export DATA_DIR=`cd $1; pwd`
	fi


	if [ -z "$SERVER_DATA_DIR" ]; then 	
		if [ -n "$TRTL_DATA_DIR" ]; then 
			export SERVER_DATA_DIR=$TRTL_DATA_DIR/turtl
		fi		
	fi


	if [ -n "$SERVER_DATA_DIR" ]; then
		assert_no_spaces "$SERVER_DATA_DIR"
	fi


	if [ -z "$SERVER_DATA_DIR" ]; then
		echo "No data directory specified. Directory argument required."
		exit 1
	else
		echo "Using $SERVER_DATA_DIR as data directory."
	fi

}


export_postgres_password () {

	export POSTGRES_PASSWORD=$1

	if [ -z "$POSTGRES_PASSWORD" ]; then 
		if [ -n "$TRTL_POSTGRES_PASSWORD" ]; then
			export POSTGRES_PASSWORD=$TRTL_POSTGRES_PASSWORD
		fi
	fi

	if [ -z "$POSTGRES_PASSWORD" ]; then
		echo "NOTE: Postgres password was not specified as parameter or environment variable, so using the default password."
		export POSTGRES_PASSWORD=eblfkp7385mfph8cy1hcmfaieahd8qkc
	fi


	if [ -n "$POSTGRES_PASSWORD" ]; then
		assert_no_spaces "$POSTGRES_PASSWORD"
	fi

}

export_email_address () {

	export EMAIL=$1
	if [ -z "$EMAIL" ]; then export EMAIL=$TRTL_EMAIL_ADDRESS; fi

	if [ -z "$EMAIL" ]; then
		echo "Error: Your email address needs to be specified as the next parameter."
		exit 1
	else
		echo "Using $EMAIL as your email address."
	fi


}


export_secure_hash_salt () {

	export SECURE_HASH_SALT="$1"
	if [ -z "$SECURE_HASH_SALT" ]; then export SECURE_HASH_SALT="$TRTL_SECURE_HASH_SALT"; fi

	if [ -z "$SECURE_HASH_SALT" ]; then
		echo "The next parameter needs to be a secure hash salt."
		exit
	else
		echo "Using a secure hash salt."
	fi

}



export_domain_name_www () {

	export DOMAIN_TWO=$1
	if [ -z "$DOMAIN_TWO" ]; then export DOMAIN_TWO=$TRTL_DOMAIN_NAME_WWW; fi

	if [ -z "$DOMAIN_TWO" ]; then
		echo "The next parameter needs to be a domain name beginning with www (example: www.domain.com)"
		exit
	else
		echo "Using $DOMAIN_TWO as the www domain name."
	fi

}

export_domain_name () {

	export DOMAIN_ONE=$1
	if [ -z "$DOMAIN_ONE" ]; then export DOMAIN_ONE=$TRTL_DOMAIN_NAME; fi

	if [ -z "$DOMAIN_ONE" ]; then
		echo "The next parameter needs to be a domain name without a subdomain (example: domain.com)"
		exit
	else
		echo "Using $DOMAIN_ONE as the domain."
	fi

}


export_tarsnap_cache_dir () {
	export TARSNAP_CACHE_DIR=$1
	if [ -n "$TARSNAP_CACHE_DIR" ]; then
		# If param is specified, then convert to absolute and use it
		export TARSNAP_CACHE_DIR="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
	fi
	
	if [ -z "$TARSNAP_CACHE_DIR" ]; then
		export TARSNAP_CACHE_DIR=$TRTL_TARSNAP_CACHE_DIR
	fi

	if [ -n "$TARSNAP_CACHE_DIR" ]; then
		assert_no_spaces "$TARSNAP_CACHE_DIR"
	fi


	if [ -z "$TARSNAP_CACHE_DIR" ]; then
		echo "ERROR: Tarsnap backup key file is not specified."
		exit 1
	else

#		if [ ! -f "$TARSNAP_CACHE_DIR" ]; then
#			echo "Unable to locate tarsnap key file at '$TARSNAP_CACHE_DIR'."
#			exit
#		else
		echo "Using $TARSNAP_CACHE_DIR as tarsnap cache directory."
#		fi
	fi

}


# Convert a (potentially relative) path to absolute; use this if function if the current user
# does not have permission to access the last folder on the path.
convert_to_absolute() {
	ABSPATH=$1
	ABS_PARENT_DIR=`cd "$ABSPATH/.."; pwd`
	export ABSPATH=$ABS_PARENT_DIR/`basename ABSPATH`
}


# Verify that the given parameter does not contain any spaces (" ").
# Turtl-docker does not support spaces in any of the path variables at this time.
assert_no_spaces() {
	string="$1"
	if [[ $string == *" "* ]]; then
		echo
		echo "Error: No spaces may be contained in the path variables: '$string' "
		echo "Ensure that the installation path does not contain a space character."
		echo
		exit
	fi
}

create_scoped_temp_dir() {
	if [ -z "$1" ]; then
		echo "No parameteter specified to create_scoped_temp_file. Exiting."
		exit 1
	fi

	delete_all_scoped_temp_dirs "$1"

#	PSEUDO_TIMESTAMP=`date +%s%N`

	#/tmp/dont-delete-$1-PSEUDO_TIMESTAMP

#	GENERATED_TMP_DIR=`mktemp -d –tmpdir="/tmp/dont-delete-$1-XXXXXXXXXXXXXXXX"`
	GENERATED_TMP_DIR=`mktemp -d "/tmp/dont-delete-$1-XXXXXXXXXXXXXXXX"`
	chmod -R 777 $GENERATED_TMP_DIR
}

delete_all_scoped_temp_dirs() {
	if [ -z "$1" ]; then
		echo "No parameteter specified to create_scoped_temp_file. Exiting."
		exit 1
	fi

	echo rm -rf "/tmp/dont-delete-$1-*"

}



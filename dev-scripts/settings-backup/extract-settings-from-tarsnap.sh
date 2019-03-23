
# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../trtl-includes.sh
include_trtl_env_vars ../../settings/trtl-env-var.sh 

# -------

export SETTINGS_ARCHIVE_NAME="$1"
if [ -z "$SETTINGS_ARCHIVE_NAME" ]; then
	echo "Error: Tarsnap archive to restore is not specified as first parameter."
	exit
fi

# Set the tarsnap key to $2 or to value from env var file ------------

export_tarsnap_key "$2"


# Set lets encrypt dir to $3 or env var file ------------

export_letsencrypt_dir "$3"


SETTINGS_TEMP_DIR=`mktemp -d`
if [ $? -ne 0 ]; then
	echo "Error: Unable to create temporary file."
	exit 1
fi


cd ../../tarsnap

./restore-to-tarsnap.sh  "$TARSNAP_KEY_FILE" "$SETTINGS_TEMP_DIR" "$SETTINGS_ARCHIVE_NAME"


echo "* Files have been extracted to '$SETTINGS_TEMP_DIR'"



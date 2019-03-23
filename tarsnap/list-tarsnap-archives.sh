#!/bin/bash


# Move to the directory of the script that included this include file ------

export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
cd $SCRIPT_LOCT

. ../dev-scripts/trtl-includes.sh
include_trtl_env_vars ../settings/trtl-env-var.sh

# -------

export_tarsnap_cache_dir ""
# TARSNAP_CACHE_DIR

mkdir -p "$TARSNAP_CACHE_DIR" >/dev/null 2>&1


. ./dev-scripts/tarsnap-includes-archive.sh

docker run --name turtl-tarsnap  \
	--rm \
	-it \
	--cap-drop=all --cap-add=chown --cap-add=kill --cap-add=dac_override \
	-v "$TARSNAP_KEY_DIRECTORY:/tarsnap/key" \
	-v "$TARSNAP_CACHE_DIR:/tarsnap/cache" \
	turtl-tarsnap \
	/tarsnap/artifacts/list-archives-internal.sh $ARCHIVE_SUFFIX
	


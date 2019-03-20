#!/bin/bash

create_scoped_temp_dir() {
	if [ -z "$1" ]; then
		echo "No parameteter specified to create_scoped_temp_file. Exiting."
		exit 1
	fi

	delete_all_scoped_temp_dirs "$1"

	GENERATED_TMP_DIR=`mktemp -d "/var/lib/postgresql/data/turtl-tmp/$1-XXXXXXXXXXXXXXXX"`
	if [[ $? != 0 ]]; then
		echo "Error: Unable to create temp file. Result: $GENERATED_TMP_DIR"
		exit 1
	fi

}


delete_all_scoped_temp_dirs() {
	if [ -z "$1" ]; then
		echo "No parameteter specified to create_scoped_temp_file. Exiting."
		exit 1
	fi

	mkdir -p /var/lib/postgresql/data/turtl-tmp >/dev/null 2>&1
	rm -rf /var/lib/postgresql/data/turtl-tmp/$1-*  >/dev/null 2>&1

}

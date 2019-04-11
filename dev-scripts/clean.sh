#!/bin/bash

echo
echo "WARNING: This operation is destructive and irreversible. It will delete all your turtl notes/images/file data."
echo

export CONFIRMATION_STRING="Yes, delete all my data $((1 + RANDOM % 100000))"

echo "To execute this operation, type the following string without square brackets: [$CONFIRMATION_STRING]"
read STRING_TO_TYPE

if [ "$STRING_TO_TYPE" == "$CONFIRMATION_STRING" ]; then

	docker rm -f turtl-server turtl-postgres turtl-nginx >/dev/null 2>&1
	set -e

	export SCRIPT_LOCT=$( cd $( dirname $0 ); pwd )
	cd $SCRIPT_LOCT/..
	
	sudo rm -rf data/
	mkdir -p data/postgres
	sudo chown -R www-data:www-data data/postgres

	mkdir -p data/turtl

	mkdir -p data/nginx-tmp/conf.d
	mkdir -p data/nginx-tmp/cache
	mkdir -p data/nginx-tmp/var-run
	sudo chown -R www-data:www-data data/nginx-tmp

	echo "* Operation complete."

else
	echo "* Values do not match."
fi


